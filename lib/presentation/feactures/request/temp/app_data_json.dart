const String solicitudDataJsonString = '''
{
  "solicitud": {
    "tipo": "Solicitud de Vacaciones",
    "codigo": "999",
    "solicitante": "María Rodríguez",
    "departamentoSolicitante": "Recepción",
    "estado": "Pendiente",
    "nivelEstado": "Nivel 8",
    "fechaSolicitud": "15/03/2025",
    "periodo": "01/04/2025 - 15/04/2025",
    "diasSolicitados": 15,
    "diasDisponibles": 20,
    "motivo": "Vacaciones anuales programadas",
    "comentarios": "Solicito mis vacaciones anuales para visitar a mi familia en Santiago.",
    "documentoAdjunto": {
      "nombre": "Justificación.pdf",
      "tamano": "1.2 MB",
      "fechaSubida": "15/03/2025"
    }
  },
  "seguimiento": {
    "progreso": 20,
    "eventos": [
      {
        "titulo": "Solicitud Creada",
        "timestamp": "15/03/2025 10:30",
        "detalle": "Cód. 999 María Rodríguez",
        "status": "completed_green",
        "nivelTag": null
      },
      {
        "titulo": "En Espera de Aprobación",
        "timestamp": null,
        "detalle": null,
        "status": "pending_yellow",
        "nivelTag": "Nivel 2"
      },
      {
        "titulo": "Aprobado",
        "timestamp": null,
        "detalle": null,
        "status": "future_gray",
        "nivelTag": null
      },
      {
        "titulo": "Corregido",
        "timestamp": "18/03/2025 14:20",
        "detalle": "Cód. 888 José Romero • Recursos Humanos",
        "status": "completed_blue",
        "nivelTag": "Nivel 1"
      },
      {
        "titulo": "Pendiente de Firma",
        "timestamp": null,
        "detalle": null,
        "status": "future_gray_level",
        "nivelTag": "Nivel 3"
      }
    ]
  },
  "informacionAdicional": {
    "idSolicitud": "REQ-001",
    "creadaPor": "María Rodríguez",
    "departamento": "Recepción"
  },
  "indicadores": {
    "tiempoAtencion": "2 días",
    "promedioTiempoAtencion": "3 días",
    "cantidadSolicitudesMes": "4",
    "promedioSolicitudesMes": "2"
  }
}
''';
