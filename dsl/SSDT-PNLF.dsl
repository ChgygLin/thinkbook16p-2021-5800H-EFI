DefinitionBlock ("", "SSDT", 2, "CORP", "PNLF", 0x00000000)
{
    Device (PNLF)
    {
        Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
        Name (_CID, "backlight")  // _CID: Compatible ID

        // _UID |     Supported Platform(s)       | PWMMax
        // -----------------------------------------------
        //  14  | Arrandale, Sandy/Ivy Bridge     | 0x0710
        //  15  | Haswell/Broadwell               | 0x0AD9
        //  16  | Skylake/Kaby Lake, some Haswell | 0x056C
        //  17  | Custom LMAX                     | 0x07A1
        //  18  | Custom LMAX                     | 0x1499
        //  19  | CoffeeLake and newer (or AMD)   | 0xFFFF
        //  99  | Other (requires custom applbkl-name/applbkl-data dev props)

        Name (_UID, 0x13)  // _UID: Unique ID: 19
        
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (0x0B)
            }
            Else
            {
                Return (Zero)
            }
        }
    }
}