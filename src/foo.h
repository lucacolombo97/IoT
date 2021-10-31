#ifndef FOO_H
#define FOO_H

typedef nx_struct radio_count_msg {
  nx_uint16_t msgCounter;
  nx_uint8_t senderID;
} radio_count_msg_t;

enum {
  AM_RADIO_COUNT_MSG = 6,
};

#endif
