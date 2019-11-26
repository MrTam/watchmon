from rtlsdr import RtlSdrTcpServer


if __name__ == '__main__':
    server = RtlSdrTcpServer(hostname='0.0.0.0', port=1234)
    server.run_forever()