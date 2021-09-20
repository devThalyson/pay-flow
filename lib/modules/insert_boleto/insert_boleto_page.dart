import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pay_flow/modules/insert_boleto/insert_boleto_controller.dart';
import 'package:pay_flow/shared/themes/app_colors.dart';
import 'package:pay_flow/shared/themes/app_text_styles.dart';
import 'package:pay_flow/shared/widgets/input_text/input_text_widget.dart';
import 'package:pay_flow/shared/widgets/set_buttons/set_label_buttons.dart';

class InsertBoletoPage extends StatefulWidget {
  final String? barcode;

  const InsertBoletoPage({
    Key? key,
    this.barcode,
  }) : super(key: key);

  @override
  _InsertBoletoPageState createState() => _InsertBoletoPageState();
}

class _InsertBoletoPageState extends State<InsertBoletoPage> {
  final moneyInputTextController = MoneyMaskedTextController(
    leftSymbol: 'R\$',
    decimalSeparator: ',',
  );

  final dueDateInputTextController = MaskedTextController(
    mask: '00/00/0000',
  );

  final barcodeInputTextController = TextEditingController();

  final _controllerView = InsertBoletoController();

  @override
  void initState() {
    if (widget.barcode != null) {
      barcodeInputTextController.text = widget.barcode!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: BackButton(
          color: AppColors.input,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 93,
                vertical: 24,
              ),
              child: Text(
                "Preencha os dados do boleto",
                style: TextStyles.titleBoldHeading,
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: _controllerView.formKey,
              child: Column(
                children: [
                  InputTextWidget(
                    label: 'Nome do boleto',
                    icon: Icons.description_outlined,
                    validator: _controllerView.validateName,
                    onChanged: (value) => {
                      _controllerView.onChanged(
                        name: value,
                      ),
                    },
                  ),
                  InputTextWidget(
                    label: 'Vencimento',
                    icon: FontAwesomeIcons.timesCircle,
                    onChanged: (value) => _controllerView.onChanged(
                      dueDate: value,
                    ),
                    controller: dueDateInputTextController,
                    validator: _controllerView.validateVencimento,
                  ),
                  InputTextWidget(
                    label: 'Valor',
                    icon: FontAwesomeIcons.wallet,
                    onChanged: (value) => _controllerView.onChanged(
                      value: moneyInputTextController.numberValue,
                    ),
                    controller: moneyInputTextController,
                    validator: (_) => _controllerView
                        .validateValor(moneyInputTextController.numberValue),
                  ),
                  InputTextWidget(
                    label: 'Código',
                    icon: FontAwesomeIcons.barcode,
                    controller: barcodeInputTextController,
                    onChanged: (value) => _controllerView.onChanged(
                      barcode: value,
                    ),
                    validator: _controllerView.validateCodigo,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SetLabelButtons(
        labelPrimary: 'Cancelar',
        onTapPrimary: () => Navigator.pop(context),
        labelSecondary: 'Cadastrar',
        onTapSecondary: () async {
          await _controllerView.cadastrarBoleto();
          Navigator.pop(context);
        },
        enableSecondaryColor: true,
      ),
    );
  }
}
