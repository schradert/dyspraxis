from math import isclose
from numpy import allclose, array, dot

def test_three_neurons():
    inputs = [1, 2, 3, 2.5]
    weights = [
        [0.2, 0.8, -0.5, 1],
        [0.5, -0.91, 0.26, -0.5],
        [-0.26, -0.27, 0.17, 0.87],
    ]
    biases = [2, 3, 0.5]
    outputs = [4.8, 1.21, 2.385]

    result = [
        sum(i * w for i, w in zip(inputs, neuron_weights)) + neuron_bias
        for neuron_weights, neuron_bias in zip(weights, biases)
    ]
    for r, o in zip(result, outputs):
        assert isclose(r, o, rel_tol=1e-9)

    outputs_np = array(outputs)
    result_np = dot(weights, inputs) + biases
    assert allclose(result_np, outputs_np, rtol=1e-9)
