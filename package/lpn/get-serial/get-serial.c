/* Copyright (C) 2018 - 2019 LPN Plant */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ETH0_ADDRESS_PATH "/sys/class/net/eth0/address"
#define ETH_ADDRESS_STR_SIZE  18

#define CHECK_PARSE(x) if (x) parse_error()

void parse_error( void )
{
        fprintf( stderr, "Error: address parsing error\n" );
        exit(1);
}

int main( int argc, char *argv[] )
{
        FILE* f;
        char mac_str[ETH_ADDRESS_STR_SIZE] = { 0 };
        size_t r;
        char *tok;
        unsigned int serial = 0;


        f = fopen( ETH0_ADDRESS_PATH, "r" );
        if ( NULL == f ) {
                fprintf( stderr, "Error: can't open address file for eth0 device!\n" );
                return 1;
        }

        r = fread( mac_str, sizeof(char), ETH_ADDRESS_STR_SIZE - 1, f );
        if ( r != ETH_ADDRESS_STR_SIZE - 1 ) {
                fprintf( stderr, "Error: address format not valid\n");
                return 1;
        }

        fclose(f);

        tok = strtok(mac_str, ":");  // 1-st byte
        CHECK_PARSE(tok == NULL);
        tok = strtok(NULL, ":");     // 2-nd byte
        CHECK_PARSE(tok == NULL);
        tok = strtok(NULL, ":");     // 3-rd byte
        CHECK_PARSE(tok == NULL);
        tok = strtok(NULL, ":");     // 4-th byte
        CHECK_PARSE(tok == NULL);
        serial = (unsigned) strtol(tok, NULL, 16) << 16;
        tok = strtok(NULL, ":");     // 5-th byte
        CHECK_PARSE(tok == NULL);
        serial |= (unsigned) strtol(tok, NULL, 16) << 8;
        tok = strtok(NULL, ":");     // 6-th byte
        CHECK_PARSE(tok == NULL);
        serial |= (unsigned) strtol(tok, NULL, 16);
        tok = strtok(NULL, ":");     // shall be null
        CHECK_PARSE(tok != NULL);

        serial /= 4;
        serial -= 64;

        printf("%d\n", serial);

        return 0;
}
