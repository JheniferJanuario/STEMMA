using STEMMA.Domain.Cadastro.Enums;

namespace STEMMA.Application.Cadastro.DTOs.Responses;

public class PetResponse
{
    public Guid Id { get; set; }

    public string Nome { get; set; } = string.Empty;

    public string Raca { get; set; } = string.Empty;

    public int Idade { get; set; }

    public decimal Peso { get; set; }

    public StatusPet Status { get; set; }

    public Guid TutorId { get; set; }
}