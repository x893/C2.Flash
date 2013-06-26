Implement Silabs C2 flash programming protocol via Arduino board.
See
https://www.silabs.com/Support%20Documents/TechnicalDocs/an127.pdf
and
http://akb77.com/g/silabs/jump-to-silabs-step-1/
for details

1. Upload C2_Flash.pde sketch to Arduino
2. Connect
    Target          Arduino        Atmel
        C2CK      - digital pin 5 (PortD 5)
        C2D       - digital pin 6 (PortD 6)
        GND       - GND
3. Start program C2.Flash.exe (need .NET 2.0)
