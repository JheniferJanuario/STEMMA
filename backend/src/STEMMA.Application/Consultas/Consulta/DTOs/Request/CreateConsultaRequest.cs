namespace STEMMA.Application.Consultas.DTOs.Requests;

public class CreateConsultationRequest
{
    public Guid PetId { get; set; }
    public Guid VeterinarioId { get; set; }
    public DateTime DataConsulta { get; set; }
}