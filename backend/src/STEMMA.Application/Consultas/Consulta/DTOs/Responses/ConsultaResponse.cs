namespace STEMMA.Application.Consultas.DTOs.Responses;

public class ConsultationResponse
{
    public Guid Id { get; set; }
    public Guid PetId { get; set; }
    public Guid VeterinarianId { get; set; }
    public DateTime DateTime { get; set; }
    public string Status { get; set; } = string.Empty;
}