from numpy import dot, ndarray, random, zeros

__all__ = ["DenseLayer"]

class DenseLayer:
    def __init__(self, n_inputs: int, n_neurons: int):
        self.weights = 0.01 * random.randn(n_inputs, n_neurons)
        self.biases = zeros((1, n_neurons))

    def forward(self, inputs: ndarray):
        self.output = dot(inputs, self.weights) + self.biases
