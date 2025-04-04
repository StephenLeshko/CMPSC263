# Constructor and Fallback Functions Flow Diagrams

## Contract Lifecycle and Special Functions

```
┌───────────────────────────────────────────────────────────────────────┐
│                         CONTRACT LIFECYCLE                             │
│                                                                       │
│  ┌──────────┐   ┌──────────────────────────────────────────────────┐  │
│  │          │   │                                                  │  │
│  │ CREATION │   │                 INTERACTION                      │  │
│  │          │   │                                                  │  │
│  └─────┬────┘   └───────────────┬───────────────┬─────────────────┘  │
│        │                        │               │                     │
│        ▼                        ▼               ▼                     │
│  ┌──────────┐        ┌────────────────┐ ┌──────────────────┐         │
│  │          │        │                │ │                  │         │
│  │CONSTRUCTOR│        │ NORMAL FUNCTION │ │ SPECIAL FUNCTION │         │
│  │          │        │                │ │                  │         │
│  └──────────┘        └────────────────┘ └──────────────────┘         │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

## Constructor Execution

```
┌───────────────────────────────────────────────────────────────────────┐
│                       CONSTRUCTOR EXECUTION                            │
│                                                                       │
│  ┌──────────────┐      ┌────────────────┐     ┌────────────────┐      │
│  │              │      │                │     │                │      │
│  │  DEPLOYMENT  │──────▶  CONSTRUCTOR   │─────▶  CONTRACT LIVE │      │
│  │              │      │     RUNS       │     │                │      │
│  └──────────────┘      └────────────────┘     └────────────────┘      │
│                                                                       │
│  Happens only ONCE at creation time                                   │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘

    - Set contract owner
    - Initialize state variables
    - Set up access controls
    - Cannot be called again
```

## Fallback/Receive Execution Flow

```
┌───────────────────────────────────────────────────────────────────────┐
│                 FALLBACK/RECEIVE EXECUTION FLOW                        │
│                                                                       │
│                 ┌────────────────────┐                                │
│                 │  Transaction sent  │                                │
│                 │   to contract      │                                │
│                 └──────────┬─────────┘                                │
│                            │                                          │
│                            ▼                                          │
│              ┌─────────────────────────────┐                          │
│              │   Does function signature   │                          │
│              │    match any function?      │                          │
│              └─────────────┬───────────────┘                          │
│                            │                                          │
│                 ┌──────────┴─────────┐                                │
│                 │                    │                                │
│                 ▼                    ▼                                │
│         ┌──────────────┐     ┌──────────────┐                         │
│         │     YES      │     │      NO      │                         │
│         └───────┬──────┘     └───────┬──────┘                         │
│                 │                    │                                │
│                 ▼                    ▼                                │
│         ┌──────────────┐     ┌──────────────┐                         │
│         │  Execute the │     │  Is msg.data │                         │
│         │   function   │     │    empty?    │                         │
│         └──────────────┘     └───────┬──────┘                         │
│                                      │                                │
│                          ┌───────────┴────────┐                       │
│                          │                    │                       │
│                          ▼                    ▼                       │
│                  ┌──────────────┐    ┌───────────────┐                │
│                  │     YES      │    │      NO       │                │
│                  └───────┬──────┘    └───────┬───────┘                │
│                          │                   │                        │
│                          ▼                   ▼                        │
│                  ┌──────────────┐    ┌───────────────┐                │
│                  │  Is receive  │    │   Execute     │                │
│                  │  defined?    │    │  fallback()   │                │
│                  └───────┬──────┘    └───────────────┘                │
│                          │                                            │
│                ┌─────────┴────────┐                                   │
│                │                  │                                   │
│                ▼                  ▼                                   │
│        ┌──────────────┐  ┌──────────────────┐                         │
│        │     YES      │  │       NO         │                         │
│        └───────┬──────┘  └─────────┬────────┘                         │
│                │                   │                                  │
│                ▼                   ▼                                  │
│        ┌──────────────┐  ┌──────────────────┐                         │
│        │   Execute    │  │  Is fallback()   │                         │
│        │  receive()   │  │    payable?      │                         │
│        └──────────────┘  └─────────┬────────┘                         │
│                                    │                                  │
│                      ┌─────────────┴──────────┐                       │
│                      │                        │                       │
│                      ▼                        ▼                       │
│              ┌──────────────┐        ┌──────────────┐                 │
│              │     YES      │        │      NO      │                 │
│              └───────┬──────┘        └───────┬──────┘                 │
│                      │                       │                        │
│                      ▼                       ▼                        │
│              ┌──────────────┐        ┌──────────────┐                 │
│              │   Execute    │        │ Transaction  │                 │
│              │  fallback()  │        │    fails     │                 │
│              └──────────────┘        └──────────────┘                 │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

## Function Gas Limits

```
┌───────────────────────────────────────────────────────────────────────┐
│                          GAS LIMITATIONS                              │
│                                                                       │
│  ┌───────────────────┬───────────────────────────────────────┐        │
│  │                   │                                       │        │
│  │   FUNCTION TYPE   │              GAS LIMIT                │        │
│  │                   │                                       │        │
│  ├───────────────────┼───────────────────────────────────────┤        │
│  │                   │                                       │        │
│  │   Constructor     │  Part of deployment (variable, high)  │        │
│  │                   │                                       │        │
│  ├───────────────────┼───────────────────────────────────────┤        │
│  │                   │                                       │        │
│  │   Normal Function │  Up to block gas limit                │        │
│  │                   │                                       │        │
│  ├───────────────────┼───────────────────────────────────────┤        │
│  │                   │                                       │        │
│  │ receive/fallback  │  2,300 gas when called via:           │        │
│  │ (with .transfer)  │  - address.transfer()                 │        │
│  │                   │  - address.send()                     │        │
│  │                   │                                       │        │
│  ├───────────────────┼───────────────────────────────────────┤        │
│  │                   │                                       │        │
│  │ receive/fallback  │  All available gas when called via:   │        │
│  │ (with .call)      │  - address.call{value: x}("")         │        │
│  │                   │                                       │        │
│  └───────────────────┴───────────────────────────────────────┘        │
│                                                                       │
│  2,300 gas is only enough for simple operations:                      │
│  - Logging events                                                     │
│  - Simple calculations                                                │
│  - NOT enough for storage operations                                  │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

## Memory vs Storage in Constructor

```
┌───────────────────────────────────────────────────────────────────────┐
│                      STATE INITIALIZATION                             │
│                                                                       │
│  ┌──────────────────────────────────────────────────────────────────┐ │
│  │                         Constructor                              │ │
│  │                                                                  │ │
│  │                                                                  │ │
│  │    Storage variables initialized here      Gas cost: HIGH        │ │
│  │    ┌───────────────────────────────┐                            │ │
│  │    │address owner = msg.sender;    │  ◄── Permanent state       │ │
│  │    │uint creationTime = block.time;│                            │ │
│  │    └───────────────────────────────┘                            │ │
│  │                                                                  │ │
│  └──────────────────────────────────────────────────────────────────┘ │
│                                                                       │
│  ┌──────────────────────────────────────────────────────────────────┐ │
│  │                      Fallback or Receive                         │ │
│  │                                                                  │ │
│  │    Storage operations here           Gas cost: TOO HIGH          │ │
│  │    ┌───────────────────────────────┐                            │ │
│  │    │counter++;         // 20k gas  │  ◄── May fail with 2300    │ │
│  │    │balances[msg.sender] = 100;    │      gas limit              │ │
│  │    └───────────────────────────────┘                            │ │
│  │                                                                  │ │
│  └──────────────────────────────────────────────────────────────────┘ │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

This visual representation helps demonstrate the different execution paths and gas constraints for constructors and fallback functions in Solidity smart contracts. 