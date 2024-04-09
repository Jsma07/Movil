import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Si _database es null, inicializar la base de datos
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'jacke.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          // Crear tablas
          await _createTables(db);

          // Insertar datos iniciales
          await _insertInitialData(db);
        },
      );
    } catch (e) {
      print('Error al inicializar la base de datos: $e');
      throw 'Error al inicializar la base de datos';
    }
  }

  Future<void> _createTables(Database db) async {
    // Crear tabla Venta
    await db.execute('''
      CREATE TABLE Venta (
        idVenta INTEGER PRIMARY KEY AUTOINCREMENT,
        empleadoId INTEGER,
        clienteId INTEGER,
        servicioId INTEGER,
       
        horaServicio TEXT,
        precio REAL,
        fechaVenta TEXT,
        estadoVenta INTEGER
      )
    ''');
    await db.execute('''
          CREATE TABLE DetalleVenta (
            idDetalle INTEGER PRIMARY KEY,
            ventaId INTEGER,
            insumoId TEXT,
            precioUnitario REAL,
            cantidadInsumo INTEGER
          )
        ''');

    // Crear tabla Servicio
    await db.execute('''
          CREATE TABLE Servicio (
            idServicio INTEGER PRIMARY KEY,
            nombreServicio TEXT,
            precioServicio REAL,
            tiempoServicio TEXT,
            imgServicio TEXT,
            estadoServicio INTEGER
          )
        ''');

    // Crear tabla Insumo
    await db.execute('''
          CREATE TABLE Insumo (
            idInsumo INTEGER PRIMARY KEY,
            nombreInsumo TEXT,
            imagenInsumo TEXT,
            cantidadInsumo INTEGER,
            usosDisponibles INTEGER,
            estadoInsumo INTEGER
          )
        ''');

    // Crear tabla InsumoXServicio
    await db.execute('''
          CREATE TABLE InsumoXServicio (
            idInsumoXServicio INTEGER PRIMARY KEY,
            servicioId INTEGER,
            cantidad INTEGER,
            insumoId INTEGER,
            FOREIGN KEY (servicioId) REFERENCES Servicio(idServicio),
            FOREIGN KEY (insumoId) REFERENCES Insumo(idInsumo)
          )
        ''');

    // Crear tabla Cliente
    await db.execute('''
          CREATE TABLE Cliente (
            idCliente INTEGER PRIMARY KEY,
            nombre TEXT,
            apellido TEXT,
            correo TEXT,
            telefono TEXT,
            contrasena TEXT,
            estado INTEGER
          )
        ''');

    // Crear tabla Empleado
    await db.execute('''
          CREATE TABLE Empleado (
            idEmpleado INTEGER PRIMARY KEY,
            nombre TEXT,
            apellido TEXT,
            correo TEXT,
            telefono TEXT,
            contrasena TEXT,
            estado INTEGER
          )
        ''');
    await db.execute('''
          CREATE TABLE Administrador (
            idAdministrador INTEGER PRIMARY KEY,
            nombre TEXT,
            apellido TEXT,
            correo TEXT,
            telefono TEXT,
            contrasena TEXT,
            estado INTEGER
          )
        ''');
  }

  Future<void> _insertInitialData(Database db) async {
    // Insertar datos de ejemplo en la tabla Cliente
    await db.insert('Cliente', {
      'idCliente': 1,
      'nombre': 'María',
      'apellido': 'García',
      'correo': 'maria@gmail.com',
      'telefono': '302546213',
      'contrasena': 'maria123',
      'estado': 1,
    });
    await db.insert('Cliente', {
      'idCliente': 2,
      'nombre': 'Juan',
      'apellido': 'Pérez',
      'correo': 'juan@gmail.com',
      'telefono': '30264516',
      'contrasena': 'juan123',
      'estado': 1,
    });
    await db.insert('Cliente', {
      'idCliente': 3,
      'nombre': 'Juan',
      'apellido': 'garcia',
      'correo': 'juangarcia@gmail.com',
      'telefono': '301123454',
      'contrasena': 'garcia123',
      'estado': 1,
    });

    // Insertar datos de ejemplo en la tabla Empleado
    await db.insert('Empleado', {
      'idEmpleado': 1,
      'nombre': 'Jackeline',
      'apellido': 'Pérez',
      'correo': 'jacke@gmail.com',
      'telefono': '30654123',
      'contrasena': 'contraseña123',
      'estado': 1,
    });
    await db.insert('Empleado', {
      'idEmpleado': 2,
      'nombre': 'Monica',
      'apellido': 'Pérez',
      'correo': 'monica@gmail.com',
      'telefono': '30265495',
      'contrasena': 'monica123',
      'estado': 1,
    });
    await db.insert('Administrador', {
      'idAdministrador': 1,
      'nombre': 'Jackeline',
      'apellido': 'arroyave',
      'correo': 'jackelinee@gmail.com',
      'telefono': '30215645',
      'contrasena': 'jackeline123',
      'estado': 1,
    });
    await db.insert('Administrador', {
      'idAdministrador': 2,
      'nombre': 'Moni',
      'apellido': 'garcia',
      'correo': 'Mon123@gmail.com',
      'telefono': '320231',
      'contrasena': 'Moni1234',
      'estado': 1,
    });
    await db.insert('Servicio', {
      'idServicio': 1,
      'nombreServicio': 'Uñas esculpidas',
      'precioServicio': 90.000,
      'tiempoServicio': '3 hora',
      'imgServicio':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRo8hUlWcwbXkr83oNIgRryvgjhrfAKHpeKBg&s',
      'estadoServicio': 1,
    });

    await db.insert('Servicio', {
      'idServicio': 2,
      'nombreServicio': 'Uñas acrilicas',
      'precioServicio': 70.000,
      'tiempoServicio': '4 horas',
      'imgServicio': '',
      'estadoServicio': 1,
    });
    await db.insert('Servicio', {
      'idServicio': 3,
      'nombreServicio': 'Uñas 3D',
      'precioServicio': 100.000,
      'tiempoServicio': '3 horas',
      'imgServicio': '',
      'estadoServicio': 1,
    });
    await db.insert('Servicio', {
      'idServicio': 4,
      'nombreServicio': 'Uñas press on',
      'precioServicio': 50.000,
      'tiempoServicio': '5 horas',
      'imgServicio': '',
      'estadoServicio': 1,
    });
    await db.insert('Servicio', {
      'idServicio': 5,
      'nombreServicio': 'Uñas permanentes',
      'precioServicio': 70.000,
      'tiempoServicio': '4 horas',
      'imgServicio': '',
      'estadoServicio': 1,
    });
    await db.insert('Servicio', {
      'idServicio': 6,
      'nombreServicio': 'Uñas Semipermanentes',
      'precioServicio': 60.000,
      'tiempoServicio': '3 horas',
      'imgServicio': '',
      'estadoServicio': 1,
    });

    await db.insert('Insumo', {
      'idInsumo': 1,
      'nombreInsumo': 'Esmalte rojo',
      'imagenInsumo':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRo8hUlWcwbXkr83oNIgRryvgjhrfAKHpeKBg&s',
      'cantidadInsumo': 20,
      'usosDisponibles': 15,
      'estadoInsumo': 1,
    });

    await db.insert('Insumo', {
      'idInsumo': 2,
      'nombreInsumo': 'Removedor de cutícula',
      'imagenInsumo':
          'data:image/jpeg;base64,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',
      'cantidadInsumo': 15,
      'usosDisponibles': 12,
      'estadoInsumo': 1,
    });

    await db.insert('Insumo', {
      'idInsumo': 3,
      'nombreInsumo': 'Crema hidratante',
      'imagenInsumo':
          'data:image/jpeg;base64,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Ozc3fNGJ2cLWLtayjL0bdFcvV1Sy6NMeRmzaFGrWWhSC5ERWYXJNySAXOp3fnLdOFyXogGs/F3UHd5K/rO7IEREBERAREQEREBERAREQEREBERA+ESr4PokofGQ5SOyWmVfFoDWqXHlb9Qdw4iB06ZmYM564c8KjjtsZ9KVOFUetP1gdKYOZBC1v9xPYPzmJStxqL6k/WBMYyDjHsDBoPxqt6gq/ORsThlAubk9bEn8t0Ds8nKRFG58ti47DYA9wE6kjbN+xp/y0/tEkwEREBERAREQEREBERAREQEREBERASs4j7ep/F8BLNKziPt6n8XwECWkymKTTXYnQbvfAk5h1z40gfVplTUru3dUCUZFxW6SbyPiN0Du7O+yp/wAtf7RJE0YAeCT+Bf7RN8BERAREQEREBERAREQEREBERAREQErmMBWu4PlHML8RYaj1yxzXXoK4s6hh1EX16x1QOOlvT6j85Lo06Z4kHqNp8fY6eS9RfQHzf3gzWdkPwrn8VNT7iIE36kvpmurh6a7z85E/ZdfhiF/oH/3j9kVeOIHqoge9jA11Mt9L27R8pGxDgdp0G8knqHp7J0F2KPKrVT6BkUfkt/zkvDbPp0zdUGbziSze01zA24RCERTvCqD2gTbEQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQP/Z',
      'cantidadInsumo': 30,
      'usosDisponibles': 25,
      'estadoInsumo': 1,
    });

    await db.insert('Insumo', {
      'idInsumo': 4,
      'nombreInsumo': 'Lima para uñas',
      'imagenInsumo':
          'data:image/jpeg;base64,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',
      'cantidadInsumo': 50,
      'usosDisponibles': 45,
      'estadoInsumo': 1,
    });

    await db.insert('Insumo', {
      'idInsumo': 5,
      'nombreInsumo': 'Aceite para cutículas',
      'imagenInsumo':
          'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxETERIREBIVEBIVFxUQEhAQEA8QGRAQFxYWGBUVFhcZHSsgGR0lGxUVITEhJSk3Li4uGB8zODMtOCgtLysBCgoKDg0OGhAQGy0lHyUtLS0tLS0rLy0wLS0tLS0tLS0vLy0rLS0vLS0tLS0tKy0tLS0tLS0tLSsvLS0tLS0tLf/AABEIAPYAzQMBEQACEQEDEQH/xAAcAAEAAgMBAQEAAAAAAAAAAAAABAUCAwYHAQj/xAA/EAACAQIEAQgHBQgCAwEAAAAAAQIDEQQSITEFBhMiQVFxcoEyM2GhsbLBFSOCkdEHFEJikpOi8FLhFiRUJf/EABoBAQADAQEBAAAAAAAAAAAAAAABAgMEBQb/xAA1EQEAAgECBAIHBwQDAQAAAAAAAQIDETEEEiFRQWETFDKRodHwBUJScYGx4SIjM8FykrIV/9oADAMBAAIRAxEAPwD3EAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABoq4ylFqM6kIye0ZTjFvybJiJlGsN6ISAAAAAAAAAAAAAAAAAAAAAAAAAABwn7S+VFSgo4bDtxqzWaVRbwg7pKPY3Z69XmdvCYIvPNbZzcRlmsaRu8jWHcp2m7t6ycuk33t7s9faOjzt50l2fI/lDUwVWFOc3PCzajKEnfmm9pQ7F2rY4uIwRkrNojr+7pw5JxzETt+z2Q8h6IAAAAAAAAAAAAAAAAAAAAAAAAAPF/2kSf2lP2KC/wAInrcJ/icHEe25apL747I9lzT7SVi3ovIrVaz9AYKV6dNvdxi/cjwJ3etDeQAAAAAAAAAAAAAAAAAAAAAAAAB4p+0Z/wD6dT8HyRPW4X/E4c/tuXqP74649lzT7SXi9l5Faps9/wCGP7ml4IfKjwbby9WNkkhIAAAAAAAAAAAAAAAAAAAAAAAAeF8vMUp8RrSjqlLJ5wSi/emetw0f24cOaf61DFXq3Z1bVc+utk7Gw6N+4pWeq9tnuPJrEqphMPNddOC/FFZZe9M8XJGl5h6NZ1rErMosAAAAAAAAAAAAAAAAAAAAAAAKXEcUm5yhC0Um45mszduveyJHNy5BYWTc5SquTu280VdvV9R0RxN4jSGU4az1lqpciMEpbVH7ed/6Jni8vdX1fHqsXyEwclb73+5f4or61kW9BRZ4DC/ulJUqMr0021GoszV9XZprrMb3m86y0rWKxpC4wWI5yEZ2te+nY07P4FUt4AAAAAAAAAAAAAAAAAAAAAADl5euqeOXxZMC0WwESPpCRZ09iqUTiOzAkcD9RH8XzMlCeAAAAAAAAAAAAAAAAAAAAAAA5eXrqnjl8SYFmtgIkfSIkWlPYhKHxHZgSeB+oj+L5mShPAAAAAAAAAAAAAAAAAAAAAAActP11Txy+LJgWi2Ahx9MiRa0tiEofEdmBJ4F6iP4vmZKE8AAAAAAAAAAAAAAAAAAAAAAByuMU4VZuVOeXNKWZQk1a7d7rQra/KmIapcoaaVlCpJ7dGKf1KRmiTRq+1He6pTflFfUemg0S/8AyRRsnRqd6Sdu8j0sJ0fHxVVk1Tp1JPsjHNbvtsTGWJnTSTRe8HpyjRgpJxers91dtmqqaAAAAAAAAAAAAAAAAAAAAABGxuNjTXS1fVFbsra0VTEaue4hxCpVTjdxi+qNlp7W9ziy8RfaKy0ikKj7MgtqlZLfStl+BT1q0fd+CfRx3ZVMBBWWaq0tdcRUX52YnifL4I5CfDoaPNWTfZiKlvyvYetW8K/D+DkhuwdHmpZ6cpp9d5qV/wBSPT5NYnlTyR3dBguN30qK38y+qOzHm5vajRSadlxGSautV1NG6j6AAAAAAAAAAAAAAAAAAAETiOMVON95PSK9vb3FbTpCYjVzdSo5Nyk7t7tnPPXdpHRgVSwnJRWZ7LVkwiSSbLIbFHN17aPv3+qI0H3mCdEsJRsRMCw4VxHI8sn0H/i+00pbTpKsw6M2UAAAAAAAAAAAAAAAAAABymNxPOVHLq2j4V/tzC06y0iNGCRUbFAkaMbTvCS7Sto6Jhspw2LIfaMLTn5P3ERuJGUkaqkAIdSBCXQcnsZnpuLd3B5fw9X1XkbUtrClo0WpdUAAAAAAAAAAAAAAAAQ+L1ctGo1vay73p9Stp0hMbuYwkeiu4whol04EoZ15wpwc5yUILVyk7JdWrL1pNukQjWFLiOU2B2eJpX8Rf1XNP3ZR6SvdhDlTgbr/ANmn/UT6rm/DKPSV7tsOUWDzNrEU7NLXMR6rm19mU89e6XQ43hptRjXpyk2koqau29ku1icGSOs1k5o7ptSLW6t36GSyNXREjPk1eFa3VNNee/0ZOLfQts6s3ZgAAAAAAAAAAAAAAACu476q3bJfr9CmT2Vq7qTCwukkY1jXpC8rOlTS/U6IrEM5lX8qMJKrhK1OO8lFL+uL+htity3iVZ2eWV+QmJbul8f0PRji6seSXyP7P8T/ALcet1PRys6HIaukkyk8VVbkTOF8ka9OtRm9o1ISfcpJlb8TWazCYr1epNX31POaK/HYFNXjo+zt7jO1Oy0SiYBWq0+9L6GeP2lp2dOdDMAAAAAAAAAAAAAAAAV3HfVrxL4Mpk2WruquH/T6lMW6bFq2d3TdO94qE1FrSyvtppe1+vyO2OTl83PPPzddvzZTpVMm7UrWV5tXllf82utv+ieavN5fl/CnLbl6z1/P+VfxuhWlBTpVebUKdWM3zzhabhaGZ57aO2ru11NERyxM6wv10jRDy1oqMuc3ayVKmLahClktKDSrPNPM3JSeb0o6qytHRPVb4LnObj09Woq056uUZPPJNyd9u2zLTy67Mo5tOkpkKdTWza0y6z9F3V29X7bFZmn19QtEX+vqWUo1b3aklvNRmrvTRQ10s99hrT6/2mYt5/XZswMalpc7vdW2elvZ7SuTl+6tj5vvINGX3sfGvmOSvtOidnSm7MAAAAAAAAAAAAAAAAV3HfVrxL4MpfZau6p4f9CmLdNkutXjBXk7K9tm9fI1taKxrKKUm06QiYrGUpJdJrdP7mrLRq2mm4pxFK/U/JN+FyW7e+Pmi1K8FTUYzeaM+ci54fEVI90o9e72as7MW4vHrr127T8ivB5IjTp74+aHzdNt56ja6TSjg8RG0pypSnvfS9PRdSe7sV9cxx390/Jb1PJ5e+PmsaNaklJKTtPM3fD17q7k1bTbpbd/aW9cxzpv7p+TP1LJGu3Xzj5t37zTea82lK2a1GstnJ6XXt9wjiscfp5T8ieEyT+vnHzTIcUpWV5621eSorvt2M5z4+7WOHydv2TW+s1Yqai+nT8UfmRz13aTs6Y6GYAAAAAAAAAAAAAAAAruOerXiXwZS+ya7qnAdXcUx7rW2TKteMFeclFXSu3bV9R01rNukQytatY1tOjZz0c2TMs1r5b62I5Z018DmjXl16sYYmDlKCknOOsop6q/aTNLREWmOkkXrNprE9YacPxbDzqOlCtTnUTcXCM4yakt1p1rsKzEp1hvhjqd3HOm08rtdpS7G9k/YW9HbTXRT0tNdNWuFR/vUo3eXmk8t3a+bexaYj0UT5qxM+mmPJLjioOWVTTlta6360U5baa6NOeszpr1ZV30Zdz+BSdllPS9On4ofMjCu7SdnTnQzAAAAAAAAAAAAAAAAFfxz1a8S+DK32TXdT4H+Hu+hlj3Xts+8Wo54wh2ykvPm6lved+C3LM2+t4cnEU56xXv8pRcLVblh6ktLqo3fsjTUX71J+ZteukXrHl8Zc+O3Nal58Yn4RCJiKzpV8JVnB01UcqE5ScNZVW5RWjuul2k9LY71iddNJj9OiOtctLTGmusT+vVT8KniMDVp8Pp1KeKw9dVnhZxa53DzSc+nbSUc0vS9r2tY550vHNPg6/ZnSF7yVrKnw2GZLPCMo1YT3dW+qlfrehplrNs0eejnxXrXBM9pnWPPVZKblVnKPpPDpq3a3dWKaRFYifxLazN7TG/KwrtfudPJ6V6eS2/O5lfzvctX/LOvn7kW/wV036afnqt8U+hLufwOSdnbG6openT8cPmRhG687OoOhmAAAAAAAAAAAAAAAAK7jvqvxL4MrfZNd1Pgv4f96jKm69tliorT2ar2P8A1s6WZzUdOitLpaLRPcc090csditRjJJTjGSTUkpRUrSWzV+siJmNjTVjQwdKDcoU4Qk95QhCLfe0hMyaPmMwUZxmkoqcllz5Vdee5emSazHZnkxRes958UfE4+jSyQaVWskoxhCKlK6X+JzZeKrSdN5nwh1YeEteItppEeMtGExrlUtzdN1XraCvzUetzqdb9iXmdGKuaac2XpHhDmy3wxk5cMaz4yuMZ6Eu5/AzttLWN1RS9On44fMjnjeF52dSdLMAAAAAAAAAAAAAAAAV3HfVrxL4MpfZNVPg/wCHyMqbwvKxidLNlJ2QFfxbjdDDQdSvNQS6t2+6K1ZEzEbr0x2vtDgsf+0TE15ZcDRVKmnrWrpScvLZe99xy5uLpi3l3YOBtfrK1jx7F1acVUlGkrdKdKMoufblTd/ysjHB61xvsRy17/X+jib8HwPW8627fX+0vhODnPSkskXpOrLVvtu+vuWnb2nr4uFw8JHTrb4/w8TLxfEcbPavw/l12BwUKUcsF4pPeT9pne83nWW2PHXHGkMsc/u5dxlbZrG6openT8cPmRhG8Lzs6o6WYAAAAAAAAAAAAAAAArePerXiXwkUvstVT4T+HyMqbwtKxckk29EldvsSOlSI16OT4xyqk044dZU/45LpeS2Xn7jky8TFXrYPs6N8nuchjI58zqvPfWTm77a9Js862fNmty4onX4/w9K04sVP6tIhU/aspy5rBU+dktHWkkqdPuT0fe9PYz0eE+x61/rz9Z7eH8vF4r7Vtb+nD08/H+HZ8n8CoQi8TU56pvLV2b9r3l7ke1bLMVilI0iHhV4Os3nJknWZ+v1ddhuKRvGKsldJJWVtbaHJNJ3dsLwySj8Q9XLu+qK32TG6qpenS8cPmRjG8Lzs6o6GYAAAAAAAAAAAAAAAArePerj4l8sjPJstXdT4XaPkZVXlp5U4uVOg8tum+ad76RcZXt7dBxeW2PHrXx6OjgcUXy9fDq4rG4eVPDyrStFJJwjK+apdpXS7Nd2c/CfZ+Tiba26V7u3i/tLHgnljrafBxXEMa6iaqPo/8Voj6jBwmLDXlxw8DNnyZrc2Sf0Y0OKZEowtGK2S0SNPRM9VphuNSaXSKziWiy34JxWUsRQjferTX+cTPJj0rM+S0T1eyHlNUbiL+7l5fErfZMbqyh6VPxQ+ZGMbwvOzqToZgAAAAAAAAAAAAAAACs4/6uPjXyyM8uy1d1Ph9l5GMLynV8NCeVTipKLzpPbMk0nbr3Om9K29qFaZLU15Z08HNcsuGQhgsXUbc5NRactcqzw0X6ndizWtetdocccPWszfefN5vS4c6c1UU41MkmssIubbVouyV9nL3PezS7JvzRpotppOqU4NuErRm45YqNOV4qUYUqiinbboR3fXLXYpr0+vOEpCw05RlB5W30M9WUrNyqXTpSypN5pRv1dFRI5ojr9fqaMeEYCVPE4SUrNSrUttcrzRdn2O91b+Vl73i1LR5SRHV7aeO2ReJv7vzRS+ya7q3CvpU/FD5kZV3Xl1J0MwAAAAAAAAAAAAAAABWcf9XHxr5ZGWbZau6mobLuMo2XlaxOtk57lzJvDxpXSjVkozvp0V0rX6tUil8lqaTWers4LDTLa3PGsRDz//AMcoNSztejmio1opt3W7crK1723Ecbn/ABfs754Lh+mlP/TB8j6N5LnqLsm9K9TWyT0/Ow9d4j8cfD5HqvC9P7Vvj80/A8k8PpF1qVs0U2qs9ItNy38h65nn7/7fJnfhuHiOmKfj826HBIUXCtCdOUoyhOKjUlJ3u2tOu2X3lbcXn062/ZNeE4e06ckx7/m9YRo8dE4q+h5/RlMmy1d1dhfSpeKHzIyrutOzqjoZgAAAAAAAAAAAAAAACu46vu14l8GZZfZWrupKGyMY2XlZ0ndI64nWGcuf5eU//W5z+GlJSl25X0dPNorbFbJpWu7r4LiKYbzN9tHndHlLTp30clZqKcX0Z3vGfemky0cBxHaPe7r8fwtvvTH6T7myfKzCS9LDJy1tJuXa2r6a7/7paf8A5+f8Me9SOOwxtlnT/ik0OU+Eat+7pK8mo5p2V0lpp/Ktesj1DN+GPeieNxb+kn/qmYXjdGpKVGnDJz86MYK7tBp2101Tbv7CLcDmiJ6dPzR67h1rPNMzGvhvq9WRLykHi0llS69/KxnknotVCwvp0vFD4ozr7S07OpOhmAAAAAAAAAAAAAAAAKzlDfmdHbpL6lMkawmN3O4eUmvS9lrIyjFPdfVKhJ9v5aF4porq+V4ZouM+nF7xl0k+9MvGsbCBPhVDroUv7VP9C/PfvPvRpDX9kYb/AOej/ZpfoT6S/efeaQ2Q4Vh+qhS/tU/0HPfvPvOjbDAUk040qcWndSVOCaa2aaWhWbWnxn3nRLVWf/J/mynLPdOrXWm9ytscz4piX3AuXO01pbNHt7SK0mJJno642UAAAAAAAAAAAAAAAAGnGYZVIOEtn19j6mRMawQpY8CmtnD3/oZxS0Lawz+yqn8vk/8AotGp0fHwyr2J/iRPUa58Lq/8fylD6kaSaw1PhFbsl/VSI5bd5+BrD79k1uyX9VMjlt3n4GsPv2VW7H/VTHJPefgawyjwmt2fnKBE45nxn4J1hu+yqjVmoL4/Ack+fvNYbMHwZxqRnJro6pR631XLVr11lEyuTRUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD/9k=',
      'cantidadInsumo': 25,
      'usosDisponibles': 20,
      'estadoInsumo': 1,
    });
    await db.insert('InsumoXServicio', {
      'idInsumoXServicio': 1,
      'servicioId': 1,
      'cantidad': 1,
      'insumoId': 1,
    });

    await db.insert('InsumoXServicio', {
      'idInsumoXServicio': 2,
      'servicioId': 1,
      'cantidad': 1,
      'insumoId': 2,
    });

    await db.insert('InsumoXServicio', {
      'idInsumoXServicio': 3,
      'servicioId': 2,
      'cantidad': 1,
      'insumoId': 3,
    });

    await db.insert('InsumoXServicio', {
      'idInsumoXServicio': 4,
      'servicioId': 2,
      'cantidad': 1,
      'insumoId': 4,
    });

    // Insertar más datos de ejemplo en otras tablas según sea necesario
    // ...
  }

  Future<List<Map<String, dynamic>>> getAdiciones() async {
    Database db = await database;
    return await db.query('Insumo');
  }

  // Future<List<Map<String, dynamic>>> getVentas() async {
  //   Database db = await database;
  //   return await db.rawQuery('''
  //   SELECT V.idVenta, V.idServicio, S.nombre AS nombreServicio, S.imageUrl AS imageUrl, V.cantidad, V.total
  //   FROM Venta V
  //   INNER JOIN Servicio S ON V.idServicio = S.idServicio
  // ''');
  // }

  Future<int> getCountVentas() async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) FROM Venta');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
  }

  Future<int> insertVenta(Map<String, dynamic> ventaData) async {
    Database db = await database;
    return await db.insert('Venta', ventaData);
  }

  Future<List<Map<String, dynamic>>> getVentas() async {
    Database db = await database;
    return await db.rawQuery('''
  SELECT V.idVenta, V.empleadoId, V.clienteId, V.servicioId, V.horaServicio, V.fechaVenta, V.estadoVenta,
       S.nombreServicio AS nombreServicio, S.imgServicio AS imageUrl, S.precioServicio AS precioServicio
FROM Venta V
INNER JOIN Servicio S ON V.servicioId = S.idServicio

  ''');
  }

  Future<void> deleteVenta(int idVenta) async {
    try {
      Database db = await database;
      int rowsAffected = await db.delete(
        'Venta', // Nombre de la tabla de la cual eliminar registros
        where:
            'idVenta = ?', // Condición para identificar el registro a eliminar
        whereArgs: [idVenta], // Valor del ID de la venta a eliminar
      );

      if (rowsAffected > 0) {
        print('Venta eliminada exitosamente');
      } else {
        print('No se encontró ninguna venta con el ID especificado');
      }
    } catch (e) {
      print('Error al eliminar la venta: $e');
      throw Exception('Error al eliminar la venta');
    }
  }
}
