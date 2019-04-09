#include <stdlib.h>
#include <jni.h>

#include <android/log.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 30000

void secret(){
	printf("Whaa. You pwned me :-)\n");
}

void important(int sock){
	char buffer[50];
	send(sock, (char*) &secret, strlen( (char*) &secret ), 0);
	read(sock, buffer, 1024);
}

int main(){
        int server_fd, new_socket, valread;
        struct sockaddr_in address;
        int opt = 1;
        int addrlen = sizeof(address);
        char msg[50] = "Every noble work is at first impossible.";
	printf("Welcome to PROJECT1NAME!\n");

	if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0){
		printf("readSocket - failed socket()\n");
		return -1;
	}
	if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) == -1) {
		printf("readSocket - failed setsockopt()\n");
		return -1;
	}
	address.sin_family = AF_INET;
        address.sin_addr.s_addr = INADDR_ANY;
        address.sin_port = htons( PORT );
	if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0){
		printf("readSocket - failed bind()");
		return -1;
	}
	if (listen(server_fd, 3) < 0){
		printf("readSocket - failed listen()");
		return -1;
	}
	if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0){
		printf("readSocket - failed accept()");
		return -1;
	}
	send(new_socket, msg, strlen(msg), 0);
	important(new_socket);
        close(server_fd);
        close(new_socket);
}
