ARCHS = arm64
TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES := SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := WolFoxGPSUltimate

WolFoxGPSUltimate_FILES := Tweak.xm WFActivation.mm WFGPSPanel.mm KSA.mm fishhook/fishhook.c
WolFoxGPSUltimate_CFLAGS := -fobjc-arc -Wno-deprecated-declarations
WolFoxGPSUltimate_FRAMEWORKS := UIKit CoreLocation MapKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
