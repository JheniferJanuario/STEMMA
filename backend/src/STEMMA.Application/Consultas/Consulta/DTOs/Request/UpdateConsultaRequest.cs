namespace STEMMA.Application.Consultas.DTOs.Requests;

public class UpdateConsultationRequest
{
    public DateTime DateTime { get; set; }
    public Guid VeterinarianId { get; set; }
}