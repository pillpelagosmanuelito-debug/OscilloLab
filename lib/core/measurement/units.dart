/// Magnitudes fisicas que el laboratorio puede medir.
enum Magnitud {
  voltajeDc,
  voltajeAc,
  corrienteDc,
  resistencia,
  frecuencia,
  amplitudPicoPico,
  temperatura,
  distancia,
}

extension MagnitudInfo on Magnitud {
  String get simbolo {
    switch (this) {
      case Magnitud.voltajeDc:
        return 'V';
      case Magnitud.voltajeAc:
        return 'Vrms';
      case Magnitud.corrienteDc:
        return 'A';
      case Magnitud.resistencia:
        return 'Ω';
      case Magnitud.frecuencia:
        return 'Hz';
      case Magnitud.amplitudPicoPico:
        return 'Vpp';
      case Magnitud.temperatura:
        return '°C';
      case Magnitud.distancia:
        return 'cm';
    }
  }

  String get nombre {
    switch (this) {
      case Magnitud.voltajeDc:
        return 'Voltaje DC';
      case Magnitud.voltajeAc:
        return 'Voltaje AC (RMS)';
      case Magnitud.corrienteDc:
        return 'Corriente DC';
      case Magnitud.resistencia:
        return 'Resistencia';
      case Magnitud.frecuencia:
        return 'Frecuencia';
      case Magnitud.amplitudPicoPico:
        return 'Amplitud pico-pico';
      case Magnitud.temperatura:
        return 'Temperatura';
      case Magnitud.distancia:
        return 'Distancia';
    }
  }
}
