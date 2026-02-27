import base64

def hex_to_base64(hex_string):
    # Convert the hex string to bytes
    bytes_object = bytes.fromhex(hex_string)

    # Convert the bytes to base64
    base64_string = base64.b64encode(bytes_object)

    # Convert the bytes object to a string and return it
    return base64_string.decode('utf-8')

hex_string = input("Enter a hexadecimal string: ")
base64_string = hex_to_base64(hex_string)
print("Base64 string: ", base64_string)

