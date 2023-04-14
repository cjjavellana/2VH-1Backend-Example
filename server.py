import sys
import http.server
import socketserver

class SimpleServer(http.server.SimpleHTTPRequestHandler):

    def do_GET(self):
        if self.path == '/login':
            self.send_response(301)
            self.send_header('Location', '/home')
            self.end_headers()
            return
        
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"<foo>bar</foo>")
    
if __name__ == "__main__":
    PORT = 8000
    handler = socketserver.TCPServer(("", PORT), SimpleServer)
    print ( "serving at port " + str(PORT) )
    handler.serve_forever()
