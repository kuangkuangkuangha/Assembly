from __future__ import unicode_literals, print_function, division

import glob
import os
import random
from io import open
import torch
import unicodedata
import string

# 处理数据

class char_set:
    all_letters = string.ascii_letters + " .,;'-"
    n_letters = len(all_letters) + 1  # Plus EOS marker 加EOS标记


class data:
    def __init__(self):
        random.seed(114514)
        self.category_lines = {}
        self.all_categories = []
        for filename in data.findFiles('data/names/*.txt'):
            category = os.path.splitext(os.path.basename(filename))[0]
            self.all_categories.append(category)
            lines = data.readLines(filename)
            self.category_lines[category] = lines
        self.n_categories = len(self.all_categories)
        if self.n_categories == 0:
            raise RuntimeError('Data not found. Make sure that you downloaded data '
                               'from https://download.pytorch.org/tutorial/data.zip and extract it to '
                               'the current directory.')

    @staticmethod
    def findFiles(path):
        return glob.glob(path)

    # Turn a Unicode string to plain ASCII, thanks to https://stackoverflow.com/a/518232/2809427
    # 将Unicode字符串转换为纯ASCII
    @staticmethod
    def unicodeToAscii(s):
        return ''.join(
            c for c in unicodedata.normalize('NFD', s)
            if unicodedata.category(c) != 'Mn'
            and c in char_set.all_letters
        )

    # Read a file and split into lines
    # 读一个文件并分成几行
    @staticmethod
    def readLines(file_path):
        with open(file_path, encoding='utf-8') as some_file:
            return [data.unicodeToAscii(line.strip()) for line in some_file]

    # One-hot vector for category
    # 类别的一个热向量
    def categoryTensor(self, category):
        li = self.all_categories.index(category)
        tensor = torch.zeros(1, self.n_categories)
        tensor[0][li] = 1
        return tensor

    # One-hot matrix of first to last letters (not including EOS) for input
    # 一个由首字母到末字母（不包括EOS）组成的热矩阵，用于输入
    @staticmethod
    def inputTensor(line):
        tensor = torch.zeros(len(line), 1, char_set.n_letters)
        for li in range(len(line)):
            letter = line[li]
            tensor[li][0][char_set.all_letters.find(letter)] = 1
        return tensor

    # LongTensor of second letter to end (EOS) for target
    # 目标的第二个字母结束（EOS）长传感器
    @staticmethod
    def targetTensor(line):
        letter_indexes = [char_set.all_letters.find(line[li]) for li in range(1, len(line))]
        letter_indexes.append(char_set.n_letters - 1)  # EOS
        return torch.LongTensor(letter_indexes)

    @staticmethod
    def randomChoice(obj):
        return obj[random.randint(0, len(obj) - 1)]

    # Get a random category and random line from that category
    # 获取一个随机类别和该类别中的随机行
    def randomTrainingPair(self):
        category = data.randomChoice(self.all_categories)
        line = data.randomChoice(self.category_lines[category])
        return category, line

    # Make category, input, and target tensors from a random category, line pair
    # 从随机类别、线对中生成类别、输入和目标张量
    def randomTrainingExample(self):
        category, line = self.randomTrainingPair()
        category_tensor = self.categoryTensor(category)
        input_line_tensor = data.inputTensor(line)
        target_line_tensor = data.targetTensor(line)
        return category_tensor, input_line_tensor, target_line_tensor
