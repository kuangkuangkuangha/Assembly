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
    #print abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ .,;'-
    n_letters = len(all_letters) + 1  # Plus EOS marker 加EOS标记


class data:
    def __init__(self):
        random.seed(114514)
        self.category_lines = {}
        self.all_categories = []
        for filename in data.findFiles('./data/names/*.txt'):
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



import torch
import torch.nn as nn

# 定义RNN网络
class RNN(nn.Module):
    def __init__(self, n_categories, input_size, hidden_size, output_size, criterion=nn.NLLLoss(), learning_rate=0.05):
        super(RNN, self).__init__()
        self.hidden_size = hidden_size
        self.cfc = nn.Linear(n_categories, 8)
        self.ifc = nn.Linear(input_size, 32)
        self.o2o = nn.Linear(hidden_size, output_size)
        self.lstm = nn.LSTM(8 + 32, hidden_size)
        self.dropout = nn.Dropout(0.1)
        self.softmax = nn.LogSoftmax(dim=2)
        self.criterion = criterion
        self.learning_rate = learning_rate

    def forward(self, category, input_, hidden, context):
        category = self.cfc(category)
        input_ = self.ifc(input_)
        input_combined = torch.cat((category, input_), 2)
        output, (hidden, context) = self.lstm(input_combined, (hidden, context))
        output = self.o2o(output)
        output = self.dropout(output)
        output = self.softmax(output)
        return output, hidden, context

    def initTensor(self):
        return torch.zeros(1, 1, self.hidden_size)

    def trainer(self, category_tensor, input_line_tensor, target_line_tensor):
        target_line_tensor.unsqueeze_(-1)
        hidden = self.initTensor()
        context = self.initTensor()
        self.zero_grad()
        loss = 0
        output = None
        category_tensor = category_tensor.view(1, 1, -1)
        for i in range(input_line_tensor.size(0)):
            input_ = input_line_tensor[i].view(1, 1, -1)
            output, hidden, context = self(category_tensor, input_, hidden, context)
            output = output.view(1, -1)
            loss_t = self.criterion(output, target_line_tensor[i])
            loss += loss_t
        loss.backward()
        for p in self.parameters():
            p.data.add_(p.grad.data, alpha=-self.learning_rate)
        return output, loss.item() / input_line_tensor.size(0)





import torch
import time
import math
import matplotlib.pyplot as plt


# 计算时间间隔
def timeSince(since):
    now = time.time()
    s = now - since
    m = math.floor(s / 60)
    s -= m * 60
    return '%dm %ds' % (m, s)

# 训练数据
def train(datas, rnn):
    train_times = 100000
    print_every = 5000
    plot_every = 5000
    all_losses = []
    total_loss = 0
    start = time.time()
    for i in range(1, train_times + 1):
        output, loss = rnn.trainer(*datas.randomTrainingExample())
        total_loss += loss
        if i % print_every == 0:
            print('%s (%d %d%%) %.4f' % (timeSince(start), i, i / train_times * 100, total_loss / plot_every))
        if i % plot_every == 0:
            all_losses.append(total_loss / plot_every)
            total_loss = 0
    plt.figure()
    plt.plot(all_losses)
    plt.savefig("./fig.png")


# Sample from a category and starting letter

# 从类别和起始字母中选取样本
def sample(datas, rnn, category, start_letter='A'):
    with torch.no_grad():  # no need to track history in sampling
        category_tensor = datas.categoryTensor(category)
        input_tensor = data.inputTensor(start_letter)
        context = rnn.initTensor()
        hidden = rnn.initTensor()
        output_name = start_letter
        max_length = 20
        category_tensor = category_tensor.view(1, 1, -1)
        input_tensor = input_tensor.view(1, 1, -1)
        for i in range(max_length):
            output, hidden, context = rnn(category_tensor, input_tensor, hidden, context)
            _, topi = output.topk(1)
            topi = topi[0][0]
            if topi == char_set.n_letters - 1:
                break
            else:
                letter = char_set.all_letters[topi]
                output_name += letter
                input_tensor = data.inputTensor(letter)
    print(output_name)


# main
def main():
    datas = data()
    print("data: ", data)
    rnn = RNN(datas.n_categories, char_set.n_letters, 128, char_set.n_letters)
    train(datas, rnn)
    sample(datas, rnn, 'Chinese', 'X')


if __name__ == '__main__':
    main()
