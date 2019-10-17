#include <avr/io.h>
#include <util/delay.h>

volatile uint8_t *pins[] = {&OCR0A, &OCR1B, &OCR0B};

uint8_t constrain(uint8_t v, uint8_t low, uint8_t high)
{
    return (v < low) ? low : ((v > high) ? high : v);
}

void set_rgb(uint8_t r, uint8_t g, uint8_t b)
{
    *pins[0] = constrain(r, 0, 255);
    *pins[1] = constrain(g, 0, 255);
    *pins[2] = constrain(b, 0, 255);
}

int main(void)
{
    DDRB = 0xFF;

    TCCR0A = 3 << COM0A0 | 3 << COM0B0 | 3 << WGM00;
    TCCR0B = 0 << WGM02 | 3 << CS00;

    GTCCR = 1 << PWM1B | 3 << COM1B0;
    TCCR1 = 3 << COM1A0 | 7 << CS10;

    while (1)
    {
        set_rgb(21, 43, 12);
        _delay_ms(100);

        set_rgb(33, 64, 135);
        _delay_ms(100);

        set_rgb(146, 32, 78);
        _delay_ms(100);
    }

    return 0;
}