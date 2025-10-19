#!/usr/bin/python3

import http.server
import socketserver
import socket
from  subprocess import call


def get_local_addr():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(('8.8.8.8', 1))  # connect() for UDP doesn't send packets
    local_ip_address = s.getsockname()[0]
    return local_ip_address

PORT = 8080
ADDRESS = get_local_addr()

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        #content_length = int(self.headers['Content-Length'])

        #post_data = self.rfile.read(content_length)


        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

        response_message = b"POST request received successfully!"
        self.wfile.write(response_message)

        print('Running provisioning script...')
        rc = call("/home/admin/temp_nodes/temp_nodes.sh", shell=True)
        if rc == 0:
            print('Done')
        else:
            print('Something went wrong')




with socketserver.TCPServer(("", PORT), CustomHandler) as httpd:
    print(f"Serving at {ADDRESS} port {PORT}, ready to handle POST requests")
    httpd.serve_forever()



