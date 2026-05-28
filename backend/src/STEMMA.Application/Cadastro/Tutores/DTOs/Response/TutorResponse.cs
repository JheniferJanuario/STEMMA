namespace STEMMA.Application.Cadastro.DTOs.Responses;

public class TutorResponse
{
    public Guid Id { get; set; }

    public string Nome { get; set; } = string.Empty;

    public string CPF { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public DateTime DataCriacao { get; set; }
}