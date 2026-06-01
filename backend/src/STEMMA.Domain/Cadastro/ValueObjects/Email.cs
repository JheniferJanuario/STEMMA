namespace STEMMA.Domain.Cadastro.ValueObjects;

public class Email
{
    public string Endereco { get; private set; }

    public Email(string endereco)
    {
        if (string.IsNullOrWhiteSpace(endereco))
            throw new Exception("Email obrigatório");

        if (!endereco.Contains("@"))
            throw new Exception("Email inválido");

        Endereco = endereco;
    }

    public override string ToString()
    {
        return Endereco;
    }
}