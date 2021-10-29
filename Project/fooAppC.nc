#include "foo.h"
#include "printf.h"
#define NEW_PRINTF_SEMANTICS

configuration fooAppC {}

implementation {

  components MainC, fooC as App;
  components new AMSenderC(AM_RADIO_COUNT_MSG);
  components new AMReceiverC(AM_RADIO_COUNT_MSG);
  components new TimerMilliC() as Timer;
  components ActiveMessageC;
  components SerialPrintfC;
  components SerialStartC;

  App.Boot -> MainC.Boot;
  
  App.Receive -> AMReceiverC;
  App.AMSend -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.Timer -> Timer;
  App.Packet -> AMSenderC;
}


