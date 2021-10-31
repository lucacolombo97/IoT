#include "Timer.h"
#include "printf.h"
#include "foo.h"

module fooC @safe() {

  uses {
    interface Boot;
    interface Receive;
    interface AMSend;
    interface Timer<TMilli> as Timer;
    interface SplitControl as AMControl;
    interface Packet;
  }
}

implementation {

  message_t packet;
  bool locked;
  // Message counters used for checking if the messages are received consecutively
  uint16_t msgCounterMote1 = 0;
  uint16_t msgCounterMote2 = 0;
  uint16_t msgCounterMote3 = 0;
  uint16_t msgCounterMote4 = 0;
  uint16_t msgCounterMote5 = 0;
  // Array of counters for the messages received by each mote
  uint16_t countersMote1[5] = {0, 0, 0, 0, 0};
  uint16_t countersMote2[5] = {0, 0, 0, 0, 0};
  uint16_t countersMote3[5] = {0, 0, 0, 0, 0};
  uint16_t countersMote4[5] = {0, 0, 0, 0, 0};
  uint16_t countersMote5[5] = {0, 0, 0, 0, 0};
  // Last message counter received by each mote
  uint16_t lastMsgCountersMote1[5] = {0, 0, 0, 0, 0};
  uint16_t lastMsgCountersMote2[5] = {0, 0, 0, 0, 0};
  uint16_t lastMsgCountersMote3[5] = {0, 0, 0, 0, 0};
  uint16_t lastMsgCountersMote4[5] = {0, 0, 0, 0, 0};
  uint16_t lastMsgCountersMote5[5] = {0, 0, 0, 0, 0};
  
  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer.startPeriodic(500); //timer for the motes to broadcast their presence
    }
    else {
      call AMControl.start();
    }
  }
  
  event void AMControl.stopDone(error_t err) {
    // do nothing
  }
  
  //Check if the mote is the number 1 and send the message
  event void Timer.fired() {
  	if (locked) {
  		return;
    }
    else {
    	// Each mote sends its message with the ID
    	radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
    	if (rcm == NULL) {
    		return;
    	}
    	rcm->senderID = TOS_NODE_ID;
    	switch(TOS_NODE_ID) {
    		case 1:
    			msgCounterMote1++;
    			rcm->msgCounter = msgCounterMote1;
    			break;
    		case 2:
    			msgCounterMote2++;
    			rcm->msgCounter = msgCounterMote2;
    			break;
    		case 3:
    			msgCounterMote3++;
    			rcm->msgCounter = msgCounterMote3;
    			break;
    		case 4:
    			msgCounterMote4++;
    			rcm->msgCounter = msgCounterMote4;
    			break;
    		case 5:
    			msgCounterMote5++;
    			rcm->msgCounter = msgCounterMote5;
    			break;
    		default:
    			break;
    	}
    	if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS) {
		  locked = TRUE;
    	}
  	}
  }
    
  event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len) {
    if (len != sizeof(radio_count_msg_t)) {return bufPtr;}
    else {
    	radio_count_msg_t* rcm = (radio_count_msg_t*)payload;
    	switch(TOS_NODE_ID) {
    		case 1:
    			if(rcm->msgCounter == lastMsgCountersMote1[rcm->senderID] + 1 || lastMsgCountersMote1[rcm->senderID] == 0) {
    				countersMote1[rcm->senderID]++;
    				lastMsgCountersMote1[rcm->senderID] = rcm->msgCounter;
    				if(countersMote1[rcm->senderID] >= 10) {
    					printf("ALARM ");
    					printf("%u ", TOS_NODE_ID);
    	    			printf("%u\n", rcm->senderID);
					}
				}
				else {
					countersMote1[rcm->senderID] = 0;
					lastMsgCountersMote1[rcm->senderID] = 0;
				}
    			break;
    		case 2:
    			if(rcm->msgCounter == lastMsgCountersMote2[rcm->senderID] + 1 || lastMsgCountersMote2[rcm->senderID] == 0) {
    				countersMote2[rcm->senderID]++;
    				lastMsgCountersMote2[rcm->senderID] = rcm->msgCounter;
    				if(countersMote2[rcm->senderID] >= 10) {
    					printf("ALARM ");
    					printf("%u ", TOS_NODE_ID);
    	    			printf("%u\n", rcm->senderID);
					}
				}
				else {
					countersMote2[rcm->senderID] = 0;
					lastMsgCountersMote2[rcm->senderID] = 0;
				}
    			break;
    		case 3:
    			if(rcm->msgCounter == lastMsgCountersMote3[rcm->senderID] + 1 || lastMsgCountersMote3[rcm->senderID] == 0) {
    				countersMote3[rcm->senderID]++;
    				lastMsgCountersMote3[rcm->senderID] = rcm->msgCounter;
    				if(countersMote3[rcm->senderID] >= 10) {
    					printf("ALARM ");
    					printf("%u ", TOS_NODE_ID);
    	    			printf("%u\n", rcm->senderID);
					}
				}
				else {
					countersMote3[rcm->senderID] = 0;
					lastMsgCountersMote3[rcm->senderID] = 0;
				}
    			break;
    		case 4:
    			if(rcm->msgCounter == lastMsgCountersMote4[rcm->senderID] + 1 || lastMsgCountersMote4[rcm->senderID] == 0) {
    				countersMote4[rcm->senderID]++;
    				lastMsgCountersMote4[rcm->senderID] = rcm->msgCounter;
    				if(countersMote4[rcm->senderID] >= 10) {
    					printf("ALARM ");
    					printf("%u ", TOS_NODE_ID);
    	    			printf("%u\n", rcm->senderID);
					}
				}
				else {
					countersMote4[rcm->senderID] = 0;
					lastMsgCountersMote4[rcm->senderID] = 0;
				}
    			break;
    		case 5:
    			if(rcm->msgCounter == lastMsgCountersMote5[rcm->senderID] + 1 || lastMsgCountersMote5[rcm->senderID] == 0) {
    				countersMote5[rcm->senderID]++;
    				lastMsgCountersMote5[rcm->senderID] = rcm->msgCounter;
    				if(countersMote5[rcm->senderID] >= 10) {
    					printf("ALARM ");
    					printf("%u ", TOS_NODE_ID);
    	    			printf("%u\n", rcm->senderID);
					}
				}
				else {
					countersMote5[rcm->senderID] = 0;
					lastMsgCountersMote5[rcm->senderID] = 0;
				}
    			break;
    		default:
    			break;
    	}
    	return bufPtr;
    }
  }
    
  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&packet == bufPtr) {
      locked = FALSE;
    }
  }
}




