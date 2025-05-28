class AppData {
  final Solicitud solicitud;
  final Seguimiento seguimiento;
  final InformacionAdicional informacionAdicional;
  final Indicadores indicadores;

  AppData({
    required this.solicitud,
    required this.seguimiento,
    required this.informacionAdicional,
    required this.indicadores,
  });

  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      solicitud: Solicitud.fromJson(json['solicitud']),
      seguimiento: Seguimiento.fromJson(json['seguimiento']),
      informacionAdicional: InformacionAdicional.fromJson(
        json['informacionAdicional'],
      ),
      indicadores: Indicadores.fromJson(json['indicadores']),
    );
  }
}

class Solicitud {
  final String tipo;
  final String codigo;
  final String solicitante;
  final String departamentoSolicitante;
  final String estado;
  final String nivelEstado;
  final String fechaSolicitud;
  final String periodo;
  final int diasSolicitados;
  final int diasDisponibles;
  final String motivo;
  final String comentarios;
  final DocumentoAdjunto documentoAdjunto;

  Solicitud({
    required this.tipo,
    required this.codigo,
    required this.solicitante,
    required this.departamentoSolicitante,
    required this.estado,
    required this.nivelEstado,
    required this.fechaSolicitud,
    required this.periodo,
    required this.diasSolicitados,
    required this.diasDisponibles,
    required this.motivo,
    required this.comentarios,
    required this.documentoAdjunto,
  });

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      tipo: json['tipo'],
      codigo: json['codigo'],
      solicitante: json['solicitante'],
      departamentoSolicitante: json['departamentoSolicitante'],
      estado: json['estado'],
      nivelEstado: json['nivelEstado'],
      fechaSolicitud: json['fechaSolicitud'],
      periodo: json['periodo'],
      diasSolicitados: json['diasSolicitados'],
      diasDisponibles: json['diasDisponibles'],
      motivo: json['motivo'],
      comentarios: json['comentarios'],
      documentoAdjunto: DocumentoAdjunto.fromJson(json['documentoAdjunto']),
    );
  }
}

class DocumentoAdjunto {
  final String nombre;
  final String tamano;
  final String fechaSubida;

  DocumentoAdjunto({
    required this.nombre,
    required this.tamano,
    required this.fechaSubida,
  });

  factory DocumentoAdjunto.fromJson(Map<String, dynamic> json) {
    return DocumentoAdjunto(
      nombre: json['nombre'],
      tamano: json['tamano'],
      fechaSubida: json['fechaSubida'],
    );
  }
}

class Seguimiento {
  final int progreso;
  final List<SeguimientoEvento> eventos;

  Seguimiento({required this.progreso, required this.eventos});

  factory Seguimiento.fromJson(Map<String, dynamic> json) {
    var eventosList = json['eventos'] as List;
    List<SeguimientoEvento> eventos =
        eventosList.map((i) => SeguimientoEvento.fromJson(i)).toList();
    return Seguimiento(progreso: json['progreso'], eventos: eventos);
  }
}

class SeguimientoEvento {
  final String titulo;
  final String? timestamp;
  final String? detalle;
  final String status;
  final String? nivelTag;

  SeguimientoEvento({
    required this.titulo,
    this.timestamp,
    this.detalle,
    required this.status,
    this.nivelTag,
  });

  factory SeguimientoEvento.fromJson(Map<String, dynamic> json) {
    return SeguimientoEvento(
      titulo: json['titulo'],
      timestamp: json['timestamp'],
      detalle: json['detalle'],
      status: json['status'],
      nivelTag: json['nivelTag'],
    );
  }
}

class InformacionAdicional {
  final String idSolicitud;
  final String creadaPor;
  final String departamento;

  InformacionAdicional({
    required this.idSolicitud,
    required this.creadaPor,
    required this.departamento,
  });

  factory InformacionAdicional.fromJson(Map<String, dynamic> json) {
    return InformacionAdicional(
      idSolicitud: json['idSolicitud'],
      creadaPor: json['creadaPor'],
      departamento: json['departamento'],
    );
  }
}

class Indicadores {
  final String tiempoAtencion;
  final String promedioTiempoAtencion;
  final String cantidadSolicitudesMes;
  final String promedioSolicitudesMes;

  Indicadores({
    required this.tiempoAtencion,
    required this.promedioTiempoAtencion,
    required this.cantidadSolicitudesMes,
    required this.promedioSolicitudesMes,
  });

  factory Indicadores.fromJson(Map<String, dynamic> json) {
    return Indicadores(
      tiempoAtencion: json['tiempoAtencion'],
      promedioTiempoAtencion: json['promedioTiempoAtencion'],
      cantidadSolicitudesMes: json['cantidadSolicitudesMes'],
      promedioSolicitudesMes: json['promedioSolicitudesMes'],
    );
  }
}
