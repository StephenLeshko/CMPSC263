# Contract Inheritance and Function Visibility Diagram

## Inheritance Structure

```
┌───────────────┐
│  TokenBase    │
└───────┬───────┘
        │ inherits
        ▼
┌───────────────┐
│  TokenPool    │
└───────┬───────┘
        │ inherits
        ▼
┌───────────────┐
│AdminExtension │
└───────────────┘
```

## Function Visibility Flow

```
                     External User/Contract
                             │
                    Can only │ access public/external
                             │ functions
                             ▼
┌─────────────────────────────────────────────┐
│ AdminExtension                              │
│                                             │
│ ┌─────────────┐        ┌─────────────────┐ │
│ │ Public      │        │ Internal        │ │
│ │ Functions   │───────▶│ Functions       │ │
│ │             │        │ (own + inherited)│ │
│ └─────────────┘        └────────┬────────┘ │
└─────────────────────────────────┼──────────┘
                                  │ can access
                                  │ parent internal
                                  ▼
┌─────────────────────────────────────────────┐
│ TokenPool                                   │
│                                             │
│ ┌─────────────┐        ┌─────────────────┐ │
│ │ Public      │        │ Internal        │ │
│ │ Functions   │───────▶│ Functions       │ │
│ │             │        │ (own + inherited)│ │
│ └─────────────┘        └────────┬────────┘ │
└─────────────────────────────────┼──────────┘
                                  │ can access
                                  │ parent internal
                                  ▼
┌─────────────────────────────────────────────┐
│ TokenBase                                   │
│                                             │
│ ┌─────────────────┐                         │
│ │ Internal        │                         │
│ │ Functions       │                         │
│ │ _transfer()     │                         │
│ │ _mint()         │                         │
│ │ _burn()         │                         │
│ └─────────────────┘                         │
└─────────────────────────────────────────────┘
```

## Function Call Example

```
User Transaction
     │
     ▼
AdminExtension.adminMint(recipient, 100)
     │
     │ (public function, accessible externally)
     │
     ▼
TokenBase._mint(recipient, 100)
     │
     │ (internal function, accessible through inheritance)
     │
     ▼
Update state variables, emit events, etc.
```

## Access Patterns

```
┌───────────────────────────────────────────────────────┐
│                                                       │
│  ┌───────────┐   ┌───────────┐    ┌───────────┐      │
│  │ External  │   │ Public    │    │ Internal  │      │
│  │ Functions │   │ Functions │    │ Functions │      │
│  └───────────┘   └───────────┘    └───────────┘      │
│        ▲               ▲                ▲            │
│        │               │                │            │
└────────┼───────────────┼────────────────┼────────────┘
         │               │                │
   ┌─────┴───────┐ ┌─────┴───────┐ ┌──────┴──────┐
   │             │ │             │ │             │
   │  External   │ │   Current   │ │  Current &  │
   │  Callers    │ │  Contract   │ │   Derived   │
   │             │ │             │ │  Contracts  │
   └─────────────┘ └─────────────┘ └─────────────┘
```

## Contract Layout Best Practice

```
CONTRACT LAYOUT BEST PRACTICE:

┌───────────────────────────────────────────┐
│ Contract                                  │
├───────────────────────────────────────────┤
│ 1. State Variables                        │
│ 2. Events                                 │
│ 3. Modifiers                              │
│ 4. Constructor                            │
├───────────────────────────────────────────┤
│ External/Public Interface:                │
│ 5. External Functions                     │
│ 6. Public Functions                       │
├───────────────────────────────────────────┤
│ Internal Implementation:                  │
│ 7. Internal Functions                     │
│ 8. Private Functions                      │
└───────────────────────────────────────────┘
```

This organizational pattern keeps the contract's public API separate from its internal implementation, making the code more maintainable and easier to understand. 