LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_LDLIBS := -llog
LOCAL_CFLAGS := -g
LOCAL_CFLAGS += -fno-stack-protector
LOCAL_SRC_FILES := main.c
LOCAL_MODULE := native-lib
include $(BUILD_EXECUTABLE)
#include $(BUILD_SHARED_LIBRARY)
