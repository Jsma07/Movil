import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl
import 'fondo_pantalla.dart';
import 'cards_detalles.dart';

class DetalleInsumo extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final Map<String, dynamic>? detallesVenta;

  const DetalleInsumo({
    Key? key,
    required this.imageUrl,
    required this.productName,
    this.detallesVenta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Detalles de la venta: $detallesVenta');

    if (detallesVenta == null || detallesVenta!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalle de $productName'),
        ),
        body: const Center(
          child: Text('No se encontraron detalles de la venta.'),
        ),
      );
    }

    final venta = detallesVenta!['venta'] as Map<String, dynamic>? ?? {};
    final cliente = venta['cliente'] as Map<String, dynamic>? ?? {};
    final empleado = venta['empleado'] as Map<String, dynamic>? ?? {};
    final adiciones = detallesVenta!['adiciones'] as List<dynamic>? ?? [];

    // Crea una instancia de NumberFormat para formatear como moneda
    final numberFormat = NumberFormat('#,##0', 'es_CO');

    // Función para formatear valores monetarios
    String formatCurrency(double value) {
      return '\$${numberFormat.format(value)}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de venta'),
      ),
      body: Stack(
        children: [
          const FondoPantalla(
            imageUrl:
                'https://i.pinimg.com/736x/71/7d/ce/717dce3d21e998822a3ca37065b932d3.jpg',
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(imageUrl),
                      onBackgroundImageError: (error, stackTrace) {
                        print('Error cargando la imagen principal: $error');
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (cliente.isNotEmpty ||
                    empleado.isNotEmpty ||
                    venta.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              icon: Icons.calendar_today,
                              title: 'Fecha:',
                              value: '${venta['Fecha'] ?? 'Desconocida'}',
                              iconColor: Colors.grey,
                            ),
                            if (cliente.isNotEmpty)
                              _buildInfoRow(
                                icon: Icons.person,
                                title: 'Cliente:',
                                value:
                                    '${cliente['Nombre'] ?? 'Desconocido'} ${cliente['Apellido'] ?? ''}',
                                iconColor: Colors.blue,
                              ),
                            if (empleado.isNotEmpty)
                              _buildInfoRow(
                                icon: Icons.work,
                                title: 'Empleado:',
                                value:
                                    '${empleado['Nombre'] ?? 'Desconocido'} ${empleado['Apellido'] ?? ''}',
                                iconColor: Colors.green,
                              ),
                            if (venta.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(
                                    icon: Icons.discount,
                                    title: 'Descuento:',
                                    value: formatCurrency(
                                        venta['Descuento']?.toDouble() ?? 0),
                                    iconColor: Colors.red,
                                  ),
                                  _buildInfoRow(
                                    icon: Icons.monetization_on,
                                    title: 'Subtotal:',
                                    value: formatCurrency(
                                        venta['Subtotal']?.toDouble() ?? 0),
                                    iconColor: Colors.orange,
                                  ),
                                  _buildInfoRow(
                                    icon: Icons.attach_money,
                                    title: 'Total:',
                                    value: formatCurrency(
                                        venta['Total']?.toDouble() ?? 0),
                                    iconColor: Colors.purple,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (adiciones.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Adiciones',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                            height:
                                10), // Espacio entre el título y el carrusel
                        SizedBox(
                          height: 200, // Ajusta la altura según el diseño
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: adiciones.length,
                            itemBuilder: (context, index) {
                              final adicion =
                                  adiciones[index] as Map<String, dynamic>;
                              final imgUrl =
                                  'http://192.168.100.44:5000/uploads/${adicion['Img'] ?? ''}';
                              return Container(
                                width: 150, // Ajusta el ancho aquí
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ProductCard(
                                  imageUrl: imgUrl,
                                  productName:
                                      adicion['NombreAdiciones']?.toString() ??
                                          'No nombre',
                                  price: formatCurrency(
                                      adicion['Precio']?.toDouble() ?? 0),
                                  units:
                                      'N/A', // Ajusta esto si tienes información sobre unidades
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
