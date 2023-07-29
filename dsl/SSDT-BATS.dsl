//
// Refer to Battery Supplement Information.md for details and formats
//

DefinitionBlock ("", "SSDT", 2, "ACDT", "BATS", 0x00000000)
{
    External (_SB_.PCI0.LPC0.H_EC.BAT0, DeviceObj)
    

    External (_SB_.PCI0.LPC0.H_EC.BFUD, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.FWVH, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.FWVL, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.HIDH, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.HIDL, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.DAVH, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.DAVL, FieldUnitObj)
    
    External (_SB_.PCI0.LPC0.H_EC.B1DC, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.B1FV, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.B1FC, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.BCYC, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.BDN1, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.B1SN, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.BVN1, FieldUnitObj)
    
    External (_SB_.PCI0.LPC0.H_EC.B1TP, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.B1TF, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.B1TE, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.B1VT, FieldUnitObj)
    
//    External (_SB_.PCI0.LPC0.H_EC.ECWR, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.B1RC, FieldUnitObj)
    External (_SB_.PCI0.LPC0.H_EC.B1CR, FieldUnitObj)
    

    Scope (\_SB.PCI0.LPC0.H_EC.BAT0)
    {
        Method (_BIX, 0, Serialized)  // _BIX: Battery Information Extended
        {
            Name (BPK1, Package (0x15)
            {
                0x01,                 /*  0x00 Add Revision                1                */
                0x00,                 /*  0x01 Power unit                  0:mW    1:mA     */
                0x00015580,           /*  0x02 Design Capacity             mWh/mAh          */
                0x00011D78,           /*  0x03 Last Full Charge Capacity   mWh/mAh          */
                0x01,                 /*  0x04 Battery Technology          1:rechargeable   */
                0x00003C00,           /*  0x05 Design Voltage              mV               */
                0x00001C8C,           /*  0x06 Design Capacity of Warning  mWh/mAh          */ 
                0x00000B6B,           /*  0x07 Design Capacity of Low      mWh/mAh          */
                0x60,                 /*  0x08 Cycle Count field                            */
                0x00017318,           /*  0x09 Measurement Accuracy        80000->80.000%   */
                0x00,                 /*  0x0a Max Sampling Time           ms               */
                0x00,                 /*  0x0b Min Sampling Time           ms               */
                0x00,                 /*  0x0c Max Averaging Interval      ms               */
                0x00,                 /*  0x0d Min Averaging Interval      ms               */
                0x64,                 /*  0x0e Battery Capacity Granularity 1               */ 
                0x00,                 /*  0x0f Battery Capacity Granularity 2               */
                "SR Real Battery",    /*  0x10 OEM-provided battery model number            */
                "00000004",          /*  0x11 OEM-provided battery serial number           */
                "LiP",                /*  0x12 OEM-provided battery type information        */
                "LENOVO",             /*  0x13 OEM-provided information                     */
                0x01                  /*  0x14 Battery Swapping Capability                  */
            })

            BPK1 [0x02] = ( B1DC * 0x0A )
//            BPK1 [0x03] = ( B1FC * 0x0A )    // this line will break the reading by VirtualSMC! Why?

            BPK1 [0x05] = B1FV
            BPK1 [0x06] = B1FC
            BPK1 [0x07] = ( B1FC * 0x0A / 0x19 )
            BPK1 [0x08] = BCYC

            BPK1 [0x10] = ToString ( BDN1, Ones )
            BPK1 [0x11] = ToHexString ( B1SN )
            
            BPK1 [0x13] = ToString ( BVN1, Ones )

            Return ( BPK1 )
        }

/*
        Method (_BST, 0, Serialized)  // _BST: Battery Status
        {
            Name (BPK1, Package (0x04)
            {
                0x01,     // Battery state, bit0/1/2/3->discharging/charging/critical/Charge Limiting
                0x01,     // Battery present rate, Provides the current rate of drain in milliwatts from the battery.
                0x01,     // Battery remaining capacity
                0x01      // Battery present voltage
            })

            Local0 = 0x01
//            If ((ECRD (RefOf (ECWR)) & 0x04))        // charging
            If (( ECWR & 0x04 ))        // charging
            {
                Local0 = 0x02
            }
            ElseIf ((ECWR & 0x08 ))    // discharging
            {
                Local0 = 0x01
            }
     
            If ((ECWR & 0x040 ))        // critical
            {
                Local0 |= 0x04
            }


            BPK1 [0x00] = Local0            // 0 -> now discharging
            BPK1 [0x01] = ( B1CR * 0x0A )     // 0mWh
            BPK1 [0x02] = ( B1RC * 0x0A )   // 73080mWh 0x11D78
            BPK1 [0x03] = B1FV              // 15360mV
            
            Return (BPK1)
        }
*/


        Method (CBIS, 0, Serialized)
        {
            Name (BPK1, Package (0x08)
            {
                // config, double check if you have valid AverageRate before
                // fliping that bit to 0x007F007F since it will disable quickPoll
                0x006F007F,            // BSS -> 0110 1111  BIS -> 0111 1111
                
                0xFFFFFFFF,            // ManufactureDate (0x1), AppleSmartBattery format
                0xFFFFFFFF,            // PackLotCode (0x2)
                0xFFFFFFFF,            // PCBLotCode (0x3)
                0xFFFFFFFF,            // FirmwareVersion (0x4)
                0xFFFFFFFF,            // HardwareVersion (0x5)
                0xFFFFFFFF,            // BatteryVersion (0x6)
                
                0xFFFFFFFF, 
            })

            BPK1 [0x01] = BFUD                // 2021.06.05    0x52C5
            BPK1 [0x02] = 0x0000AE86
            BPK1 [0x03] = 0x000068EA
            BPK1 [0x04] = ( FWVH * 0x100 + FWVL )
            BPK1 [0x05] = ( HIDH * 0x100 + HIDL )
            BPK1 [0x06] = ( DAVH * 0x100 + DAVL )

            Return ( BPK1 )
        } 



        Method (CBSS, 0, Serialized)
        {
            Name (BPK1, Package (0x08)
            {
                
                0xFFFFFFFF,                 // Temperature     (0x10), AppleSmartBattery format
                0xFFFFFFFF,                 // TimeToFull      (0x11), minutes (0xFF)
                0xFFFFFFFF,                 // TimeToEmpty     (0x12), minutes (0)
                0xFFFFFFFF,                 // ChargeLevel     (0x13), percentage
                0xFFFFFFFF,                 // AverageRate     (0x14), mA (signed)
                0xFFFFFFFF,                 // ChargingCurrent (0x15), mA
                0xFFFFFFFF,                 // ChargingVoltage (0x16), mV
                
                                            // Disable SMC key for temperature (0x17), set config bit only
                0x0                         // publishTemperatureKey = true
            })
            
            Local0 = ( B1RC * 0x64 / B1DC )
            If ((Local0 > 0x64))
            {
                Local0 = 0x64
            }

            BPK1 [0x00] = B1TP
            BPK1 [0x01] = B1TF
            BPK1 [0x02] = B1TE
            BPK1 [0x03] = Local0
            BPK1 [0x04] = B1CR
            BPK1 [0x05] = ( B1CR * 0x2710 / B1VT )    // 0x0A * 0x03E8
            BPK1 [0x06] = B1VT

            Return ( BPK1 )
        }

    }
}
//EOF
