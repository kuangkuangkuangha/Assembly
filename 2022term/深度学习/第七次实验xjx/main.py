from data import data
from data import char_set
from module import RNN
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
