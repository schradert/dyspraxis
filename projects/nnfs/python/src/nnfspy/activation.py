from numpy import exp, max, maximum, ndarray, sum

__all__ = ["ReLu", "Softmax"]

class ReLu:
    def forward(self, inputs: ndarray):
        self.output = maximum(0, inputs)

class Softmax:
    def forward(self, inputs: ndarray):
        # Maximize at 1.0 for maximum input (exponent 0)
        values = exp(inputs - max(inputs, axis=1, keepdims=True))
        self.output = values / sum(values, axis=1, keepdims=True)
