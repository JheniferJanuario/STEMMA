namespace STEMMA.Application.Cadastro.DTOs.Requests;

public class CreatePetRequest
{
    public string Nome { get; set; } = string.Empty;

    public string Raca { get; set; } = string.Empty;

    public int Idade { get; set; }

    public decimal Peso { get; set; }

    public Guid TutorId { get; set; }
}