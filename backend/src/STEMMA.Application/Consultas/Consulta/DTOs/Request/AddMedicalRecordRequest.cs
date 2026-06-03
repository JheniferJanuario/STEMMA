namespace STEMMA.Application.Consultas.DTOs.Requests;

public class AddMedicalRecordRequest
{
    public Guid ConsultationId { get; set; }

    public string Description { get; set; } = string.Empty;

    public string Diagnostico { get; set; } = string.Empty;

    public string Tratamento { get; set; } = string.Empty;

    public string Medicacao { get; set; } = string.Empty;

    public decimal? Peso { get; set; }
}