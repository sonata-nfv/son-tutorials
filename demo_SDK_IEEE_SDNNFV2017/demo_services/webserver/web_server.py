from flask import Flask, Response
import os

app = Flask(__name__)

@app.route('/')
def index():
    return 'Hello world'

# return a dummy file with given size in MB
@app.route('/file/<size>')
def dummy_file(size):
    size_bytes = int(float(size) * 2**20)
    byte_array = bytearray(size_bytes)

    resp = Response(response=byte_array,status=200)
    resp.headers['Content-Length'] = size_bytes
    # need this to enable squid to cache the file
    resp.cache_control.max_age = 300

    return resp


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8888)