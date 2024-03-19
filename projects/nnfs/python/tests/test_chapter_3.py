from numpy import allclose, array, dot

def test_2x3_layer_three_samples():
    inputs = array([
        [1, 2, 3, 2.5],
        [2., 5., -1., 2],
        [-1.5, 2.7, 3.3, -0.8],
    ])
    weights1 = array([
        [0.2, 0.8, -0.5, 1],
        [0.5, -0.91, 0.26, -0.5],
        [-0.26, -0.27, 0.17, 0.87],
    ])
    biases1 = array([2, 3, 0.5])
    weights2 = array([
        [0.1, -0.14, 0.5],
        [-0.5, 0.12, -0.33],
        [-0.44, 0.73, -0.13],
    ])
    biases2 = array([-1, 2, -0.5])
    outputs = array([
        [0.5031, -1.04185, -2.03875],
        [0.2434, -2.7332, -5.7633],
        [-0.99314, 1.41254, -0.35655],
    ])

    outputs1 = dot(inputs, weights1.T) + biases1
    outputs2 = dot(outputs1, weights2.T) + biases2
    assert allclose(outputs2, outputs, rtol=1e-9)
