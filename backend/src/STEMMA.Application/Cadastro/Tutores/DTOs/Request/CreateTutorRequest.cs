namespace STEMMA.Application.Cadastro.DTOs.Requests;

public class CreateTutorRequest
{
    public string Nome { get; set; } = string.Empty;

    public string CPF { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;
}