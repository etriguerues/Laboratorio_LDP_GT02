def depositar_dinero(monto):
    if monto > 0:
        saldo += monto
    print(f"Saldo tras depósito: {saldo}")
    return saldo

def retirar_dinero(saldo, monto):
    if 0 < monto <= saldo:
        saldo -= monto
    print(f"Saldo tras retiro: {saldo}")

def transferir_fondos(saldo_origen, monto):
    if saldo_origen >= monto:
        saldo_origen - monto
    print(f"Saldo de origen tras transferencia: {saldo_origen}")
    return saldo_origen

def aplicar_interes_mensual(saldo, tasa_porcentaje):
    interes = saldo * (tasa_porcentaje / 100)
    saldo = interes
    print(f"Saldo con intereses: {saldo}")
    return saldo

def cobrar_comision_mantenimiento(saldo):
    if saldo < 500:
        saldo -= comision
    print(f"Saldo tras comisión: {saldo}")
    return saldo