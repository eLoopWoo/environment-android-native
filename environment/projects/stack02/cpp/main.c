#include <stdlib.h>
#include <jni.h>

#include <android/log.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 20002

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
        __android_log_write(ANDROID_LOG_INFO, "stack02", "secret_function");
}

JNIEXPORT jstring JNICALL
Java_com_zenysec_stack02_MainActivity_getString(JNIEnv *env, jobject obj){
        int i;
        i = rand() % (sizeof(messages) / sizeof(messages[0]));
        return (*env)->NewStringUTF(env, messages[i]);
}

JNIEXPORT void JNICALL
Java_com_zenysec_stack02_MainActivity_vulnFunc(JNIEnv *env, jobject obj){

	int server_fd, new_socket, valread;
	struct sockaddr_in address;
	int opt = 1;
	int addrlen = sizeof(address);
	
        char msg[10] = {0};
        msg[4] = (char) (int) secret_function & 0xff;
        msg[5] = (char) (((int) secret_function >> 8) & 0xff);
        msg[6] = (char) (((int) secret_function >> 16) & 0xff);
        msg[7] = (char) (((int) secret_function >> 24) & 0xff);

        typedef struct{
                char buffer[5];
                void (*func_ptr)();
        } locals;
        locals l = {.buffer = {0}, .func_ptr = 0x1337};

        global_env = env;
        global_cls = (*global_env)->FindClass(global_env, "com/zenysec/stack02/SecretClass");
        global_method = (*global_env)->GetStaticMethodID(global_env, global_cls, "secretMethod", "()V");

	__android_log_write(ANDROID_LOG_INFO, "stack02", "readSocket - start");

	if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0){
		__android_log_write(ANDROID_LOG_ERROR, "stack02", "readSocket - failed socket()");
		return;
	}


	if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) == -1) {
		__android_log_write(ANDROID_LOG_ERROR, "stack02", "readSocket - failed setsockopt()");
		return;
	}

	__android_log_write(ANDROID_LOG_ERROR, "stack02", "readSocket - successes setsockopt()");

	address.sin_family = AF_INET;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons( PORT );

	if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0){
		__android_log_write(ANDROID_LOG_ERROR, "stack02", "readSocket - failed bind()");
		return;
	}
	__android_log_write(ANDROID_LOG_ERROR, "stack02", "readSocket - successes bind()");

	if (listen(server_fd, 3) < 0){
		__android_log_write(ANDROID_LOG_ERROR, "stack02", "readSocket - failed listen()");
		return;
	}
	__android_log_write(ANDROID_LOG_ERROR, "stack02", "readSocket - successes listen()");

	if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0){
		__android_log_write(ANDROID_LOG_ERROR, "stack02", "readSocket - failed accept()");
		return;
	}
	__android_log_write(ANDROID_LOG_ERROR, "stack02", "readSocket - successes accept()");

	valread = read(new_socket, l.buffer, 1024);
	__android_log_write(ANDROID_LOG_ERROR, "stack02", "readSocket - successes read()");
	__android_log_write(ANDROID_LOG_ERROR, "stack02", l.buffer);
	send(new_socket, msg, strlen(msg), 0);
	__android_log_write(ANDROID_LOG_ERROR, "stack02", "readSocket - successes send()");

	close(server_fd);
	close(new_socket);
	__android_log_write(ANDROID_LOG_ERROR, "stack02", "readSocket - successes close()");
	
	if ( l.func_ptr != 0x1337){
                l.func_ptr();
        }

	return;
}
