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
        sum(i*w for i, w in zip(inputs, neuron_weights)) + neuron_bias
        for neuron_weights, neuron_bias in zip(weights, biases)
    ]
    assert result == outputs
