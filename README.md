# SPI Master Controller with Tx/Rx FIFO

## Overview

This project implements a configurable **SPI Master Controller** in **Verilog HDL** with integrated **Transmit (Tx) FIFO** and **Receive (Rx) FIFO** buffers.

The controller supports all four SPI operating modes through configurable **Clock Polarity (CPOL)** and **Clock Phase (CPHA)** settings. Data transmission is initiated when valid data is available in the Tx FIFO, enabling continuous byte streaming without software intervention for each transfer.

For verification, a simple SPI Slave model was developed that receives data from the master and echoes the received byte back through the MISO line. The returned data is stored in the Rx FIFO when the controller operates in read mode (`RW = 1`).

The design operates from a **100 MHz system clock** and generates a **10 MHz SPI clock** for serial communication.

---

## Features

* Verilog HDL implementation of SPI Master
* Supports all four SPI modes:
* Full-duplex serial communication
* Integrated Tx FIFO and Rx FIFO
* FIFO-triggered data transmission
* Continuous multi-byte streaming support
* Configurable clock polarity and phase
* FSM-based controller architecture
* 100 MHz system clock
* 10 MHz SPI serial clock

---

## Architecture
<img width="500" height="400" alt="SPI_Arch" src="https://github.com/user-attachments/assets/9f9e3ce5-b934-4492-92eb-7e6f9f4fa52c" />

**Note:**
The SPI Slave is used only for verification purposes. It echoes the received byte back to the master and is not intended to represent a complete production SPI Slave implementation.

---

## Verification

### SPI Mode Verification

All four SPI modes were verified:

| Mode | CPOL | CPHA |
| ---- | ---- | ---- |
| 0    | 0    | 0    |
| 1    | 0    | 1    |
| 2    | 1    | 0    |
| 3    | 1    | 1    |

<img width="1870" height="1340" alt="SPI_Modes" src="https://github.com/user-attachments/assets/c31b7ce2-ff80-4b55-95bf-24f848c8f967" />


Verification included:

* Clock polarity validation
* Clock phase validation
* Correct MOSI/MISO timing
* Continuous byte streaming
* Full-duplex operation

---

### Stress Testing

The following data patterns were transmitted through the complete communication path: 

      00, FF, AA, 55, 81, 18, 7E, E7

These patterns were selected to verify:

* All-zero transfers
* All-one transfers
* Alternating bit patterns
* Mixed-bit transitions
* MSB and LSB handling

---

##  Waveform

### Continuous Data Transmission & FIFO Verification

<img width="1919" height="872" alt="testbench_1cb" src="https://github.com/user-attachments/assets/02f72577-39c3-4e8d-9b80-cd290d6251e1" />

---

### Corner Case Verification

Successfully verified:

* FIFO full condition
* FIFO empty condition
* Continuous back-to-back transfers
* Reset during active transfer
* Transmit underflow handling
* Correct Rx FIFO storage operation

---

## Learning Outcomes

Through this project I gained practical experience in:

* Verilog RTL Design
* Finite State Machine (FSM) Design
* SPI Protocol Implementation
* FIFO Architecture
* CPOL and CPHA Timing Analysis
* Serial Communication Verification
* Digital Design Debugging and Validation

---

## Author

**Elavarasan**

---

##  Notes

This project was implemented from scratch without copying reference designs, focusing on understanding and robustness.

---
