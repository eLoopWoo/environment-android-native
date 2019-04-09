#include <stdlib.h>
#include <jni.h>

#include <android/log.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 20001

static const char *const messages[] = {
        "[0] AAAA",
        "[1] BBBB",
        "[2] CCCC",
        "[3] DDDD"
};


JNIEnv *global_env;
jclass global_cls;
jmethodID global_method;

void secret_function(){
        (*global_env)->CallStaticVoidMethod(global_env, global_cls, global_method);
        __android_log_write(ANDROID_LOG_INFO, "stack01", "secret_function");
}

JNIEXPORT jstring JNICALL
Java_com_zenysec_stack01_MainActivity_getString(JNIEnv *env, jobject obj){
        int i;
        i = rand() % (sizeof(messages) / sizeof(messages[0]));
        return (*env)->NewStringUTF(env, messages[i]);
}

JNIEXPORT void JNICALL
Java_com_zenysec_stack01_MainActivity_vulnFunc(JNIEnv *env, jobject obj){

	int server_fd, new_socket, valread;
	struct sockaddr_in address;
	int opt = 1;
	int addrlen = sizeof(address);
	
        char msg[50] = "Every noble work is at first impossible.";

        typedef struct{
                char buffer[5];
                char str[10];
        } locals;

        locals l = {.buffer = {0}, .str = "user"};

        global_env = env;
        global_cls = (*global_env)->FindClass(global_env, "com/zenysec/stack01/SecretClass");
        global_method = (*global_env)->GetStaticMethodID(global_env, global_cls, "secretMethod", "()V");

	__android_log_write(ANDROID_LOG_INFO, "stack01", "readSocket - start");

	if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0){
		__android_log_write(ANDROID_LOG_ERROR, "stack01", "readSocket - failed socket()");
		return;
	}


	if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) == -1) {
		__android_log_write(ANDROID_LOG_ERROR, "stack01", "readSocket - failed setsockopt()");
		return;
	}

	__android_log_write(ANDROID_LOG_ERROR, "stack01", "readSocket - successes setsockopt()");

	address.sin_family = AF_INET;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons( PORT );

	if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0){
		__android_log_write(ANDROID_LOG_ERROR, "stack01", "readSocket - failed bind()");
		return;
	}
	__android_log_write(ANDROID_LOG_ERROR, "stack01", "readSocket - successes bind()");

	if (listen(server_fd, 3) < 0){
		__android_log_write(ANDROID_LOG_ERROR, "stack01", "readSocket - failed listen()");
		return;
	}
	__android_log_write(ANDROID_LOG_ERROR, "stack01", "readSocket - successes listen()");

	if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0){
		__android_log_write(ANDROID_LOG_ERROR, "stack01", "readSocket - failed accept()");
		return;
	}
	__android_log_write(ANDROID_LOG_ERROR, "stack01", "readSocket - successes accept()");

	valread = read(new_socket, l.buffer, 1024);
	__android_log_write(ANDROID_LOG_ERROR, "stack01", "readSocket - successes read()");
	__android_log_write(ANDROID_LOG_ERROR, "stack01", l.buffer);
	send(new_socket, msg, strlen(msg), 0);
	__android_log_write(ANDROID_LOG_ERROR, "stack01", "readSocket - successes send()");

	close(server_fd);
	close(new_socket);
	__android_log_write(ANDROID_LOG_ERROR, "stack01", "readSocket - successes close()");
	
        if ( !( strcmp(l.str, "admin") )){
                secret_function();
        }

	return;
}
