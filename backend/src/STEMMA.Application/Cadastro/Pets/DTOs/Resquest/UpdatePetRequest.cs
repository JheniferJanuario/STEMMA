using STEMMA.Domain.Cadastro.Enums;

namespace STEMMA.Application.Cadastro.DTOs.Requests;

public class UpdatePetRequest
{
    public string Nome { get; set; } = string.Empty;

    public string Raca { get; set; } = string.Empty;
    public int Idade { get; set; }
    public decimal Peso { get; set; }
    public StatusPet Status { get; set; }
}