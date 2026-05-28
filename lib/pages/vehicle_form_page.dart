import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../models/vehicle.dart';
import '../services/local_data_service.dart';

class VehicleFormPage extends StatefulWidget {
  final Vehicle? vehicle;
  const VehicleFormPage({super.key, this.vehicle});

  @override
  State<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends State<VehicleFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String type;
  final brandCtrl = TextEditingController();
  final modelCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final transmissionCtrl = TextEditingController();
  final colorCtrl = TextEditingController();
  final platePrefixCtrl = TextEditingController(text: 'S');
  final plateCtrl = TextEditingController();

  bool get isEdit => widget.vehicle != null;

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    type = v?.type ?? 'Motor';
    brandCtrl.text = v?.brand ?? '';
    modelCtrl.text = v?.model ?? '';
    yearCtrl.text = v?.year ?? '';
    transmissionCtrl.text = v?.transmission ?? '';
    colorCtrl.text = v?.color ?? '';
    platePrefixCtrl.text = v?.platePrefix.isNotEmpty == true ? v!.platePrefix : 'S';
    plateCtrl.text = v?.plateNumber ?? '';
  }

  @override
  void dispose() {
    brandCtrl.dispose();
    modelCtrl.dispose();
    yearCtrl.dispose();
    transmissionCtrl.dispose();
    colorCtrl.dispose();
    platePrefixCtrl.dispose();
    plateCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final vehicle = Vehicle(
      id: widget.vehicle?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      brand: brandCtrl.text.trim(),
      model: modelCtrl.text.trim(),
      year: yearCtrl.text.trim(),
      transmission: transmissionCtrl.text.trim(),
      color: colorCtrl.text.trim(),
      platePrefix: platePrefixCtrl.text.trim().toUpperCase(),
      plateNumber: plateCtrl.text.trim().toUpperCase(),
      isMain: widget.vehicle?.isMain ?? false,
    );
    await LocalDataService.upsertVehicle(vehicle);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(children: [
          _header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.warmBorder)),
                child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label('Jenis Kendaraan *'),
                    Row(children: [
                      _VehicleOption(label: 'Motor', asset: AppAssets.motor, selected: type == 'Motor', onTap: () => setState(() => type = 'Motor')),
                      const SizedBox(width: 8),
                      _VehicleOption(label: 'Mobil', asset: AppAssets.mobil, selected: type == 'Mobil', onTap: () => setState(() => type = 'Mobil')),
                      const SizedBox(width: 8),
                      _VehicleOption(label: 'Truk/Bus', asset: AppAssets.truk, selected: type == 'Truk/Bus', onTap: () => setState(() => type = 'Truk/Bus')),
                    ]),
                    const SizedBox(height: 10),
                    _label('Merk *'),
                    _field(controller: brandCtrl, hint: 'Tuliskan Merk Kendaraan (misal: Honda)', icon: _vehicleIcon(), requiredField: true),
                    const SizedBox(height: 8),
                    _label('Model *'),
                    _field(controller: modelCtrl, hint: 'Tuliskan Tipe Kendaraan (misal: Beat Karbu)', icon: _vehicleIcon(), requiredField: true),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _label('Tahun *'),
                        _field(controller: yearCtrl, hint: 'Tuliskan Tahun Kendaraan', icon: Icons.calendar_month, requiredField: true, keyboardType: TextInputType.number),
                      ])),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _label('Transmisi *'),
                        _field(controller: transmissionCtrl, hint: 'Tuliskan Transmisi (misal: Matic)', icon: Icons.settings, requiredField: true),
                      ])),
                    ]),
                    const SizedBox(height: 8),
                    _label('Warna'),
                    _field(
                      controller: colorCtrl,
                      hint: 'Tuliskan Warna Kendaraan',
                      icon: Icons.circle,
                      prefix: Padding(
                        padding: const EdgeInsets.only(left: 14, right: 8),
                        child: Center(
                          widthFactor: 1,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: _colorForName(colorCtrl.text),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _label('Nomor Polisi *'),
                    Row(children: [
                      SizedBox(
                        width: 56,
                        child: _field(
                          controller: platePrefixCtrl,
                          hint: 'S',
                          textStyle: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                          fillColor: AppColors.navy,
                          icon: Icons.confirmation_number,
                          requiredField: true,
                          noPrefixIcon: true,
                          showCheckIcon: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: _field(controller: plateCtrl, hint: '5555 TLD', icon: Icons.confirmation_number, requiredField: true)),
                    ]),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: const Text('Simpan Kendaraan', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _header() => Container(
        height: 130,
        width: double.infinity,
        color: AppColors.navy,
        child: Stack(children: [
          const Positioned(right: -44, top: -66, child: CircleAvatar(radius: 94, backgroundColor: Color(0x333B82F6))),
          Positioned(left: 18, top: 42, child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.white15, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.chevron_left, color: Colors.white, size: 27)))),
          const Positioned(top: 49, left: 0, right: 0, child: Center(child: Text('Tambah/Edit Kendaraan', style: TextStyle(fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)))),
        ]),
      );

  Widget _label(String text) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.darkGray)));

  Widget _field({required TextEditingController controller, required String hint, required IconData icon, bool requiredField = false, TextInputType? keyboardType, Widget? prefix, bool noPrefixIcon = false, TextStyle? hintStyle, TextStyle? textStyle, TextAlign? textAlign, Color? fillColor, bool showCheckIcon = true}) {
    return TextFormField(
      controller: controller,
      onChanged: (_) => setState(() {}),
      keyboardType: keyboardType,
      validator: requiredField ? (v) => v == null || v.trim().isEmpty ? 'Wajib diisi' : null : null,
      textAlign: textAlign ?? TextAlign.start,
      style: textStyle ?? const TextStyle(fontSize: 13, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintStyle ?? const TextStyle(color: AppColors.gray, fontSize: 12),
        filled: true,
        fillColor: fillColor ?? const Color(0xFFF9F8F6),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        prefixIcon: prefix ?? (noPrefixIcon ? null : _FieldIcon(icon: icon)),
        suffixIcon: showCheckIcon && controller.text.trim().isNotEmpty ? const Icon(Icons.check_circle, color: AppColors.orange, size: 18) : null,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: AppColors.warmBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: AppColors.orange, width: 1.4)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: AppColors.red, width: 1.2)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: AppColors.red, width: 1.2)),
      ),
    );
  }

  IconData _vehicleIcon() => type == 'Mobil' ? Icons.directions_car : type == 'Truk/Bus' ? Icons.local_shipping : Icons.two_wheeler;

  Color _colorForName(String value) {
    final text = value.toLowerCase();
    if (text.contains('hitam')) return Colors.black87;
    if (text.contains('putih')) return Colors.white;
    if (text.contains('merah')) return Colors.red;
    if (text.contains('biru')) return Colors.blue;
    if (text.contains('kuning')) return Colors.yellow;
    if (text.contains('hijau')) return Colors.green;
    if (text.contains('silver') || text.contains('abu')) return Colors.grey;
    return const Color(0xFFD9D9D9);
  }
}

class _VehicleOption extends StatelessWidget {
  final String label;
  final String asset;
  final bool selected;
  final VoidCallback onTap;
  const _VehicleOption({required this.label, required this.asset, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 42,
            decoration: BoxDecoration(color: selected ? AppColors.orange12 : const Color(0xFFF9F8F6), borderRadius: BorderRadius.circular(12), border: Border.all(color: selected ? AppColors.orange : AppColors.warmBorder)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Image.asset(asset, width: 18, height: 18, fit: BoxFit.contain), const SizedBox(width: 4), Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: selected ? AppColors.orange : AppColors.darkGray)))]),
          ),
        ),
      );
}

class _FieldIcon extends StatelessWidget {
  final IconData icon;
  const _FieldIcon({required this.icon});

  @override
  Widget build(BuildContext context) => Container(width: 50, margin: const EdgeInsets.only(right: 10), decoration: const BoxDecoration(border: Border(right: BorderSide(color: AppColors.warmBorder))), child: Center(child: CircleAvatar(radius: 11, backgroundColor: Color(0xFFD0D0D0), child: Icon(icon, size: 14, color: Colors.white))));
}
