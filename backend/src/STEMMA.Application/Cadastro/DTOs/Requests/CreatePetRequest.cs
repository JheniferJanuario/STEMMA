namespace STEMMA.Application.Cadastro.DTOs.Requests;

public class CreatePetRequest
{
    public string Nome { get; set; }
    public string Raca { get; set; }
    public Guid TutorId { get; set; }
}