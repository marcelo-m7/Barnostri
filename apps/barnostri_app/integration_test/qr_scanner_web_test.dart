@TestOn('browser')
import 'dart:html' as html;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qr_code_scanner/src/web/jsqr.dart';

const _qrBase64 = 'iVBORw0KGgoAAAANSUhEUgAAASIAAAEiAQAAAAB1xeIbAAABiElEQVR4nO2ZQWrDMBBF/68NWdqQA+Qo1s1yNesoOUDBWgZsfheSkrShtIsqcu3xQhjxwJ/RaPQ1pvDz499+AQFGGWWUUUatnWJ6WgCBpAt5xlXVtQtqkCRNAHmaAaCRJOkz9Xpdu6BCynHpcogRT9ugsq4tU+3z1EIhlPuiUd9RdGhE98Iv7pfKed8JQAAEzHHm8dK1VvWboDxJsgfoQgsAS7Q5tXVtmop5f89x+R5M26Cmrj1QiFZymJo4SNNtTnN807hW9f+bStFNEZ/xaQHmZPwt9qUpupCtvesk8/elqVxVujTcb7hWc0pTt3oPIHYScuUHOqs5Rambz0nGhsN4pXxu6rCWrj1QMfbZxzezfP8OIBAAllzw16p+E9S9ygPprI3Vp7KuXVC5j8nzBGgMLch+sXttSeprH1O+n4RhOgLDuORTYK3qt0XxfGlB110JhEPuaNbXtUXquY8Zh6PgT1da3hek8PhrEI2ALtl96ymUpp76mGkQEJeiki6jjDLKKKP+lvoALsHfLYaAkWAAAAAASUVORK5CYII=';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('jsQR decodes sample image', (tester) async {
    final img = html.ImageElement(src: 'data:image/png;base64,' + _qrBase64);
    await img.onLoad.first;
    final canvas = html.CanvasElement(width: img.width!, height: img.height!);
    final ctx = canvas.context2D;
    ctx.drawImage(img, 0, 0);
    final imageData = ctx.getImageData(0, 0, canvas.width!, canvas.height!);
    final code = jsQR(imageData.data, canvas.width, canvas.height);
    expect(code.data, 'test-qr');
  });
}
