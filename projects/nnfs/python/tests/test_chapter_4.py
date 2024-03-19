from nnfs import init
from nnfs.datasets import spiral_data
from numpy import array, allclose

from nnfspy import DenseLayer, ReLu, Softmax

init()
x, y = spiral_data(samples=100, classes=3)

def test_dense_relu():
    output = array([
        [0, 0, 0],
        [0, 0.00011395, 0],
        [0, 0.00031729, 0],
        [0, 0.00052666, 0],
        [0, 0.00071401, 0],
    ])
    dense = DenseLayer(2, 3)
    act = ReLu()

    dense.forward(x)
    act.forward(dense.output)

    assert allclose(act.output[:5], output, rtol=1e-9)

def test_dense_relu_dense_softmax():
    output = array([
        [0.33333334, 0.33333334, 0.33333334],
        [0.33333316, 0.3333332, 0.33333364],
        [0.33333287, 0.3333329, 0.33333418],
        [0.3333326, 0.33333263, 0.33333477],
        [0.33333233, 0.3333324, 0.33333528],
    ])
    dense1 = DenseLayer(2, 3)
    act1 = ReLu()
    dense2 = DenseLayer(3, 3)
    act2 = Softmax()

    dense1.forward(x)
    act1.forward(dense1.output)
    dense2.forward(act1.output)
    act2.forward(dense2.output)

    # Need to decrease the closeness tolerance
    assert allclose(act2.output[:5], output, rtol=1e-5)
