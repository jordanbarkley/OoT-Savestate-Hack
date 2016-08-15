// Common macros

macro asciiz(string) {
    db {string}, 0x00
}

macro hexB(value) {
    db {value}
}

macro hexH(value) {
    dw {value}
}

macro hexW(value) {
    dd {value}
} 

macro hexDW(value) {
    dq {value}
}

macro lwi(reg, value) {
    lui {reg}
}
