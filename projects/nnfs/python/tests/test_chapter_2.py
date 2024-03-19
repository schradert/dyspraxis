from math import isclose
from numpy import allclose, array, dot

def test_three_neurons_one_sample_list():
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

def test_three_neurons_one_sample_numpy():
    inputs = array([1, 2, 3, 2.5])
    weights = array([
        [0.2, 0.8, -0.5, 1],
        [0.5, -0.91, 0.26, -0.5],
        [-0.26, -0.27, 0.17, 0.87],
    ])
    biases = array([2, 3, 0.5])
    outputs = array([4.8, 1.21, 2.385])

    result = dot(weights, inputs) + biases
    assert allclose(result, outputs, rtol=1e-9)

def test_three_neurons_three_samples_numpy():
    inputs = array([
        [1.0, 2.0, 3.0, 2.5],
        [2.0, 5.0, -1.0, 2.0],
        [-1.5, 2.7, 3.3, -0.8],
    ])
    weights = array([
        [0.2, 0.8, -0.5, 1.0],
        [0.5, -0.91, 0.26, -0.5],
        [-0.26, -0.27, 0.17, 0.87],
    ])
    biases = array([2.0, 3.0, 0.5])
    outputs = array([
        [4.8, 1.21, 2.385],
        [8.9, -1.81, 0.2],
        [1.41, 1.051, 0.026],
    ])

    result = dot(inputs, weights.T) + biases
    assert allclose(result, outputs, rtol=1e-9)
