/**************************************************************
 * HTTPPrint.h
 * Provides callback headers and resolution for user's custom
 * HTTP Application.
 * 
 * This file is automatically generated by the MPFS Utility
 * ALL MODIFICATIONS WILL BE OVERWRITTEN BY THE MPFS GENERATOR
 **************************************************************/

#ifndef __HTTPPRINT_H
#define __HTTPPRINT_H

#include "TCPIP Stack/TCPIP.h"

#if defined(STACK_USE_HTTP2_SERVER)

extern HTTP_STUB httpStubs[MAX_HTTP_CONNECTIONS];
extern BYTE curHTTPID;

void HTTPPrint(DWORD callbackID);
void HTTPPrint_Site(void);
void HTTPPrint_config_mac(void);
void HTTPPrint_macdis(void);
void HTTPPrint_config_hostname(void);
void HTTPPrint_config_ip(void);
void HTTPPrint_config_subnet(void);
void HTTPPrint_config_gw(void);
void HTTPPrint_setup(void);
void HTTPPrint_IsResetIp(void);
void HTTPPrint_OldIP(void);
void HTTPPrint_HardwareVer(void);
void HTTPPrint_SoftwareVer(void);
void HTTPPrint_StackVer(void);
void HTTPPrint_McuType(void);

void HTTPPrint(DWORD callbackID)
{
	switch(callbackID)
	{
        case 0x00000000:
			HTTPPrint_Site();
			break;
        case 0x0000000e:
			HTTPPrint_config_mac();
			break;
        case 0x0000000f:
			HTTPPrint_macdis();
			break;
        case 0x00000010:
			HTTPPrint_config_hostname();
			break;
        case 0x00000011:
			HTTPPrint_config_ip();
			break;
        case 0x00000012:
			HTTPPrint_config_subnet();
			break;
        case 0x00000013:
			HTTPPrint_config_gw();
			break;
        case 0x00000017:
			HTTPPrint_setup();
			break;
        case 0x00000018:
			HTTPPrint_IsResetIp();
			break;
        case 0x00000019:
			HTTPPrint_OldIP();
			break;
        case 0x0000001b:
			HTTPPrint_HardwareVer();
			break;
        case 0x0000001c:
			HTTPPrint_SoftwareVer();
			break;
        case 0x0000001d:
			HTTPPrint_StackVer();
			break;
        case 0x0000001e:
			HTTPPrint_McuType();
			break;
		default:
			// Output notification for undefined values
			TCPPutROMArray(sktHTTP, (ROM BYTE*)"!DEF", 4);
	}

	return;
}

void HTTPPrint_(void)
{
	TCPPut(sktHTTP, '~');
	return;
}

#endif

#endif
