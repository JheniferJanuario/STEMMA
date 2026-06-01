namespace STEMMA.Domain.Cadastro.ValueObjects;

public class CPF
{
    public string Numero { get; private set; }

    public CPF(string numero)
    {
        if (string.IsNullOrWhiteSpace(numero))
            throw new Exception("CPF obrigatório");

        numero = numero
            .Replace(".", "")
            .Replace("-", "")
            .Trim();

        if (numero.Length != 11)
            throw new Exception("CPF deve possuir 11 dígitos");

        if (!numero.All(char.IsDigit))
            throw new Exception("CPF deve conter apenas números");

        Numero = numero;
    }

    public override string ToString()
    {
        return Numero;
    }
}