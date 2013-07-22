void setup() {
  // square wave on pin 9
  DDRB |= _BV(PORTB1); // pin 9 is an output
  TCCR1A = _BV(COM1A0); // toggle on Compare Match
  TCCR1B = _BV(CS10) | _BV(CS11) | _BV(WGM12); // prescalar=64; CTC mode
  OCR1A = 2; // toggle after 2 cycles (8uS period = 125kHz)
}

void loop() {
  // main code here eventually
}
