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
